import 'dart:math';
import 'dart:typed_data';

import 'package:chatdrop/infra/utilities/convert.dart';
import 'package:chatdrop/infra/utilities/file_type.dart';
import 'package:chatdrop/modules/chat/presentation/cubit/chat_page/chat_page_cubit.dart';
import 'package:chatdrop/modules/chat/presentation/cubit/chat_page/chat_page_state.dart';
import 'package:chatdrop/modules/chat/presentation/cubit/can_chat/can_chat_cubit.dart';
import 'package:chatdrop/modules/chat/presentation/cubit/can_chat/can_chat_state.dart';
import 'package:chatdrop/modules/chat/presentation/widgets/select_file_dialog.dart';
import 'package:chatdrop/shared/cubit/auth/auth_cubit.dart';
import 'package:chatdrop/shared/cubit/auth/auth_state.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:chatdrop/shared/illustrations/chats.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:chatdrop/shared/tools/avatar_image_provider.dart';
import 'package:chatdrop/shared/tools/snackbar_message.dart';
import 'package:chatdrop/shared/widgets/loading.dart';
import 'package:chatdrop/shared/widgets/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../shared/models/message_model/secret_message_model.dart';
import '../bloc/secret_chat/secret_chat_bloc.dart';
import '../bloc/secret_chat/secret_chat_event.dart';
import '../bloc/secret_chat/secret_chat_state.dart';
import '../../../../shared/controllers/secret_chat_controller.dart';
import '../cubit/chatting_status/chatting_status_cubit.dart';
import '../widgets/secret_message.dart';

class SecretChatPage extends StatefulWidget {
  final UserModel user;

  const SecretChatPage({Key? key, required this.user}) : super(key: key);

  @override
  State<SecretChatPage> createState() => _SecretChatPageState();
}

class _SecretChatPageState extends State<SecretChatPage> {
  late ThemeState theme;
  final TextEditingController _messageController = TextEditingController();
  final SecretChatController _chatController = SecretChatController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final List<SecretMessageModel> _selectedMessages = <SecretMessageModel> [];

  /// initializing chat controller
  Future<void> _initializeChatController() async {
    await _chatController.init(widget.user);
    await _chatController.sendMessageReadSignal();
    _chatController.changeStatus('online');
    _chatController.responseListener((SecretMessageModel message) async {
      if(message.senderUid == widget.user.uid.toString()) {
        if (message.messageType == 'NEW') {
          // adding message to chat list
          await _addMessageToChatList(message);
          await _chatController.sendMessageReadSignal();
        } else if (message.messageType == 'DEL') {
          // deleting messages from local storage as well as in chat list
          await _chatController.deleteMessageFromLocalStorage(message.id!);
          _deleteMessagesInChatList(<SecretMessageModel>[message]);
        } else if (message.messageType == 'INTERRUPT') {
          SecretMessageModel? messageModel = await _chatController.retrieveSingleMessageFromLocalStorage(message.id!);
          if(messageModel != null) {
            _chatController.sendRecoveredInterruptedMessage(messageModel);
          }
        } else if (message.messageType == 'RECOVER') {
          _chatController.recoverMessageInLocalStorage(message);
          _recoverInterruptedMessage(message);
        } else if(message.messageType == 'READ') {
          _chatController.readAllMessages();
          _readMessagesInChatList();
        } else if(message.messageType == 'STATUS') {
          BlocProvider.of<ChattingStatusCubit>(context).updateStatus(message.refer!);
        }
      }
    });
  }

  /// sending message
  Future<void> _sendMessage(String senderUid, {String contentType = 'TEXT', String? contentName, Uint8List? fileBytes}) async {
    if ((_chatController.isInitialized && _messageController.value.text.isNotEmpty) || contentType != 'Text') {
      // loading sender next pre-key bundle model
      await _chatController.loadSenderPreKeyBundleModel();

      // calculating message id and datetime
      final id = Random().nextInt(10000) + Random().nextInt(100);
      final datetime = DateTime.now();

      // setting content according to content type
      String? content;
      if (contentType == 'IMAGE' || contentType == 'VIDEO') {
        content = bytesToBase64(fileBytes!);
      }

      // sending message to remote user with encryption
      _chatController.send(SecretMessageModel(
          id: id,
          senderUid: senderUid,
          messageType: 'NEW',
          contentType: contentType,
          content: SecretMessageContentModel(
            text: _messageController.value.text,
            contentName: contentName,
            content: content,
          ).toString(),
          time: datetime.millisecondsSinceEpoch,
          senderPreKeyBundle: _chatController.senderPreKeyBundleModel
      ));

      // adding message directly to chat list without encryption
      await _addMessageToChatList(SecretMessageModel(
          id: id,
          senderUid: senderUid,
          messageType: 'NEW',
          contentType: contentType,
          content: SecretMessageContentModel(
            text: _messageController.value.text,
            contentName: contentName,
            content: content,
          ).toString(),
          time: datetime.millisecondsSinceEpoch,
          senderPreKeyBundle: _chatController.senderPreKeyBundleModel
      ));

      // making text field blank
      _messageController.text = '';
    }
  }

  /// add message to chat list
  Future<void> _addMessageToChatList(SecretMessageModel message) async {
    if (mounted) {
      // storing message in local storage
      SecretMessageModel storedMessage = await _chatController.storeMessageInLocalStorage(message);

      // add message to chat list
      if (mounted) {
        BlocProvider.of<SecretChatBloc>(context).add(AddSecretChatEvent(storedMessage));
      }

      _scrollChatListToEnd();
    }
  }

  /// read message in chat list
  void _readMessagesInChatList() {
    BlocProvider.of<SecretChatBloc>(context).add(ReadSecretChatEvent());
  }

  /// delete message in chat list
  void _deleteMessagesInChatList(List<SecretMessageModel> messages) {
    BlocProvider.of<SecretChatBloc>(context).add(DeleteSecretChatEvent(messages));
    BlocProvider.of<SecretChatBloc>(context).add(ClearSelectionEvent(_selectedMessages));
  }

  /// clear messages in chat list
  void _clearChatListMessages() {
    BlocProvider.of<SecretChatBloc>(context).add(ClearSecretChatEvent());
    BlocProvider.of<SecretChatBloc>(context).add(ClearSelectionEvent(_selectedMessages));
  }

  /// recover interrupted chat
  void _recoverInterruptedMessage(SecretMessageModel message) {
    BlocProvider.of<SecretChatBloc>(context).add(RecoverInterruptedMessageEvent(message));
  }

  /// remove from recent chats
  void _removeFromRecentChats() {
    if(_chatController.isInitialized) {
      _chatController.deleteFromRecent();
    }
  }

  /// Scrolling to the end after 1 sec when comment is posted
  void _scrollChatListToEnd() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 50,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
  }

  /// function for picking image for story
  Future<Map<String, dynamic>?> _pickFile(FileType type) async {
    try {
      XFile? file;
      if (type == FileType.image) {
        file = await _imagePicker.pickImage(source: ImageSource.gallery);
      } else if (type == FileType.video) {
        file = await _imagePicker.pickVideo(source: ImageSource.gallery);
      }
      if (file != null) {
        int fileLength = await file.length();
        if (fileLength / 1000000 <= 50) {
          Uint8List fileBytes = await file.readAsBytes();
          return {
            'name': file.name,
            'bytes': fileBytes,
          };
        } else {
          if (mounted) {
            ErrorSnackBar.show(context, '50MB file size is allowed.');
          }
          return null;
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  /// opens dialog for file selection
  void _showPickFileDialog(BuildContext context, String senderUid) {
    showModalBottomSheet(context: context, builder: (context) {
      return SelectFileDialog(
        onImageSelectPressed: () {
          _pickFile(FileType.image).then((fileData) async {
            if (fileData != null) {
              await _sendMessage(
                senderUid,
                contentType: 'IMAGE',
                contentName: fileData['name'],
                fileBytes: fileData['bytes'],
              );
            }
          });
          if (mounted) {
            Navigator.pop(context);
          }
        },
        onVideoSelectPressed: () async {
          _pickFile(FileType.video).then((fileData) async {
            if (fileData != null) {
              await _sendMessage(
                senderUid,
                contentType: 'VIDEO',
                contentName: fileData['name'],
                fileBytes: fileData['bytes'],
              );
            }
          });
          if (mounted) {
            Navigator.pop(context);
          }
        },
      );
    });
  }

  /// opens dialog for deleting messages confirmations
  void _showDeleteMessagesAlertDialog(bool onlyOneMessage, String senderUid) {
    if(_selectedMessages.isEmpty) {
      return;
    }
    showDialog(context: context, builder: (_) {
      return AlertDialog(
        title: const Text('Delete Messages ?'),
        content: const Text('Are you sure, you want to delete message.'),
        actions: [
          if (onlyOneMessage && _selectedMessages[0].senderUid == senderUid && !_selectedMessages[0].isDeleted!)
            TextButton(
              child: const Text('Delete from everyone'),
              onPressed: () async {
                await _chatController.deleteMessageFromEveryone(_selectedMessages[0].id!);
                if (mounted) {
                  _deleteMessagesInChatList(_selectedMessages);
                  Navigator.of(_).pop();
                }},
            ),
          TextButton(
            child: const Text('Delete from me'),
            onPressed: () async {
              await _chatController.deleteMessageFromMe(_selectedMessages);
              if (mounted) {
                _deleteMessagesInChatList(_selectedMessages);
                Navigator.of(_).pop();
              }},
          ),
          TextButton(
            child: const Text('close'),
            onPressed: () {
              Navigator.of(_).pop();},
          ),
        ],
      );
    });
  }

  /// opens dialog for clear chat confirmation
  void _showClearChatAlertDialog() {
    showDialog(context: context, builder: (_) {
      return AlertDialog(
        title: const Text('Clear Chats ?'),
        content: const Text('Are you sure, you want to delete all chat messages.'),
        actions: [
          TextButton(
            child: const Text('close'),
            onPressed: () {
              Navigator.of(_).pop();
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () async {
              await _chatController.clearChats();
              if (mounted) {
                _clearChatListMessages();
                Navigator.of(_).pop();
              }
            },
          ),
        ],
      );
    });
  }

  @override
  void initState() {
    super.initState();
    // getting current theme
    theme = BlocProvider.of<ThemeCubit>(context).state;
    // initializing chat controller
    _initializeChatController().then((value) async {
      // listing old messages
      BlocProvider.of<SecretChatBloc>(context).add(ListSecretChatEvent(
        await _chatController.retrieveMessagesFromLocalStorage(),
      ));
      Future.delayed(const Duration(milliseconds: 1000), () {
        _scrollChatListToEnd();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthState>(builder: (context, authState) {
      if (authState is Authenticated) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: Avatar.getAvatarProvider(
                    widget.user.gender.toString(),
                    widget.user.photo,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.name.toString(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      StreamBuilder<DocumentSnapshot>(
                        stream: _chatController.listenStatusSignal(),
                        builder: (context, snapshot) {
                          String status = 'offline';

                          if (snapshot.hasData && snapshot.data!.data() != null) {
                            status = (snapshot.data!.data() as Map<String, dynamic>)['status'];
                          }

                          return Text(
                            status,
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              BlocBuilder<ChatPageCubit, ChatPageState>(
                  builder: (context, state) {
                    if (state == ChatPageState.onlyOneMessageSelected || state == ChatPageState.manyMessagesSelected) {
                      return IconButton(
                        onPressed: () {
                          if (state == ChatPageState.onlyOneMessageSelected) {
                            _showDeleteMessagesAlertDialog(true, authState.uid);
                          } else if (state == ChatPageState.manyMessagesSelected){
                            _showDeleteMessagesAlertDialog(false, authState.uid);
                          }
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.blue,
                        ),
                      );
                    }
                    return Container();
                  }
              ),
              BlocBuilder<ChatPageCubit, ChatPageState>(
                  builder: (context, state) {
                    if (state == ChatPageState.onlyOneMessageSelected || state == ChatPageState.manyMessagesSelected) {
                      return IconButton(
                        onPressed: () {
                          if (state == ChatPageState.onlyOneMessageSelected || state == ChatPageState.manyMessagesSelected) {
                            BlocProvider.of<SecretChatBloc>(context).add(ClearSelectionEvent(_selectedMessages));
                            BlocProvider.of<ChatPageCubit>(context).setMessagesUnselected();
                          }
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.blue,
                        ),
                      );
                    }
                    return Container();
                  }
              ),
              BlocBuilder<ChatPageCubit, ChatPageState>(
                  builder: (context, state) {
                    if (state == ChatPageState.initial || state == ChatPageState.messageUnselected) {
                      return PopupMenuButton(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.blue,
                        ),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem<String>(
                              value: 'Clear Chats',
                              child: const Text('Clear Chats'),
                              onTap: () {
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  _showClearChatAlertDialog();
                                });
                              },
                            ),
                            PopupMenuItem<String>(
                              value: 'Remove From Recent',
                              child: const Text('Remove From Recent'),
                              onTap: () {
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  _removeFromRecentChats();
                                  SuccessSnackBar.show(context, 'Removed from recent chats.');
                                });
                              },
                            ),
                          ];
                        },
                      );
                    }
                    return Container();
                  }
              ),
            ],
          ),
          body: Column(
            children: [
              /// Chats List
              const SizedBox(height: 1),
              Expanded(
                flex: 1,
                child: BlocBuilder<SecretChatBloc, SecretChatState>(
                  builder: (context, state) {
                    if (state is SecretChatListState) {

                      if (state.messages.isEmpty) {
                        return const Chats(
                          height: 300,
                          label: 'Your chats are end-to-end-encrypted and secured on your device. '
                                'Secret chats are deleted automatically when you logout or uninstall the app.',
                        );
                      }

                      return GroupedListView<SecretMessageModel, DateTime>(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        controller: _scrollController,
                        elements: state.messages,
                        useStickyGroupSeparators: true,
                        floatingHeader: true,
                        stickyHeaderBackgroundColor: Colors.transparent,
                        sort: false,
                        groupBy: (message) {
                          final dateTime = DateTime.fromMillisecondsSinceEpoch(message.time!);
                          return DateTime(dateTime.year, dateTime.month, dateTime.day);
                        },
                        groupSeparatorBuilder: (datetime) {
                          return const SizedBox(height: 5);
                        },
                        groupHeaderBuilder: (message) {
                          return Container(
                            height: 40,
                            color: theme == ThemeState.light ? Colors.white : Colors.black,
                            child: Center(
                              child: Card(
                                color: Colors.blue,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  child: Text(
                                    DateFormat('MMM d, yyyy').format(
                                      DateTime.fromMillisecondsSinceEpoch(message.time!),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemBuilder: (context, message) {
                          return GestureDetector(
                            key: Key(message.id.toString()),
                            onLongPress: () {
                              // message selection event
                              BlocProvider.of<SecretChatBloc>(context).add(SecretMessageSelectionEvent(message.id!, _selectedMessages));

                              // delayed 100 mills because message selection event takes time in changing state
                              Future.delayed(const Duration(milliseconds: 100), () {
                                // changing chat page state for options according to selected messages
                                if(_selectedMessages.isEmpty) {
                                  BlocProvider.of<ChatPageCubit>(context).setMessagesUnselected();
                                } else {
                                  BlocProvider.of<ChatPageCubit>(context).setMessagesSelected(_selectedMessages.length);
                                }
                              });
                              },
                            child: Container(
                              decoration: BoxDecoration(
                                color: message.isSelected! ? theme == ThemeState.light ? Colors.blue.shade50 : Colors.grey.shade900 : null,
                              ),
                              child: SecretMessage(
                                message: message,
                                sameUser: authState.uid == message.senderUid,
                                chatController: _chatController,
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const Loading();
                  },
                ),
              ),

              /// divider
              const Divider(),

              /// Message Sender
              BlocBuilder<CanChatCubit, CanChatState>(
                builder: (context, state) {
                  if (state == CanChatState.initial) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 7),
                      // decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5)),
                      child: const CenterMessage(message: 'Loading...'),
                    );
                  }

                  // checking if user is unavailable to chat
                  if (state == CanChatState.unavailable) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 7),
                      // decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5)),
                      child: const ErrorMessage(message: 'chats are closed till your friend login to app'),
                    );
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 7),
                    // decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5)),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _showPickFileDialog(context, authState.uid);
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.blue,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _messageController,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type a message',
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent)
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent)
                              ),
                            ),
                            onTap: () {
                              if (_chatController.isInitialized) {
                                _chatController.changeStatus('typing');
                              }
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await _sendMessage(authState.uid);
                            Future.delayed(const Duration(milliseconds: 500), () {
                              _chatController.changeStatus('online');
                            });
                          },
                          icon: const Icon(
                            Icons.send_outlined,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              ),
            ],
          ),
        );
      }
      return const ErrorMessage(message: 'Please login again.');
    });
  }

  @override
  void dispose() {
    _chatController.changeStatus('offline');
    _messageController.dispose();
    _chatController.dispose();
    super.dispose();
  }
}
