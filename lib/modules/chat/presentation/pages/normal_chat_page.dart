import 'dart:async';
import 'dart:typed_data';

import 'package:chatdrop/infra/utilities/file_type.dart';
import 'package:chatdrop/shared/controllers/normal_chat_controller.dart';
import 'package:chatdrop/modules/chat/presentation/widgets/message.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/cubit/auth/auth_cubit.dart';
import 'package:chatdrop/shared/cubit/auth/auth_state.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:chatdrop/shared/illustrations/chats.dart';
import 'package:chatdrop/shared/models/message_model/message_model.dart';
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

import '../cubit/chat_page/chat_page_cubit.dart';
import '../cubit/chat_page/chat_page_state.dart';
import '../widgets/select_file_dialog.dart';

class NormalChatPage extends StatefulWidget {
  final UserModel user;
  const NormalChatPage({Key? key, required this.user}) : super(key: key);

  @override
  State<NormalChatPage> createState() => _NormalChatPageState();
}

class _NormalChatPageState extends State<NormalChatPage> {
  late ThemeState theme;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final NormalChatController _chatController = NormalChatController();
  final ImagePicker _imagePicker = ImagePicker();

  /// sending message
  Future<void> _sendMessage({String contentType = 'TEXT', String? contentName, Uint8List? fileBytes}) async {
    try {
      String content = _messageController.value.text;
      if (contentType == 'TEXT' && content.isEmpty) {
        return;
      }
      if (contentType == 'IMAGE' || contentType == 'VIDEO') {
        content =
        await _chatController.uploadMessageAttachment(contentName!, fileBytes!);
      }
      _chatController.sendMessage(
        MessageModel(
          contentType: contentType,
          content: content,
          time: DateTime.now().millisecondsSinceEpoch,
        ),
      );

      _messageController.text = '';
    } catch (e) {
      ErrorSnackBar.show(context, 'Unable to deliver message.');
    }
  }

  /// Scrolling to the end after 1 sec when comment is posted
  void _scrollChatListToEnd() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
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
        if (fileLength / 1000000 <= 100) {
          Uint8List fileBytes = await file.readAsBytes();
          return {
            'name': file.name,
            'bytes': fileBytes,
          };
        } else {
          if (mounted) {
            ErrorSnackBar.show(context, '100MB file size is allowed.');
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
    if(_chatController.selectedMessages.isEmpty) {
      return;
    }
    showDialog(context: context, builder: (_) {
      return AlertDialog(
        title: const Text('Delete Messages ?'),
        content: const Text('Are you sure, you want to delete message.'),
        actions: [
          if (onlyOneMessage && _chatController.selectedMessages[0].senderUid == senderUid && !_chatController.selectedMessages[0].isDeleted!)
            TextButton(
              child: const Text('Delete from everyone'),
              onPressed: () async {
                _chatController.deleteMessageFromEveryone();
                if (mounted) {
                  Navigator.of(_).pop();
                }},
            ),
          TextButton(
            child: const Text('Delete from me'),
            onPressed: () async {
              _chatController.deleteMessageFromMe();
              if (mounted) {
                Navigator.of(_).pop();
              }},
          ),
          TextButton(
            child: const Text('close'),
            onPressed: () {
              _chatController.selectedMessages.clear();
              Navigator.of(_).pop();
            },
          ),
        ],
      );
    });
  }

  @override
  void initState() {
    super.initState();
    theme = BlocProvider.of<ThemeCubit>(context).state;
    _chatController.init(widget.user,
      onDeleteFromEveryone: () {
        BlocProvider.of<ChatPageCubit>(context).setMessagesUnselected();
      },
      onDeleteFromMe: () {
        BlocProvider.of<ChatPageCubit>(context).setMessagesUnselected();
      }
    );
    _chatController.changeStatus('online');
    _chatController.listenMessageSignal().listen((event) {
      _scrollChatListToEnd();
      MessageModel message = MessageModel.fromJson(event.docChanges.first.doc.data()!);
      _chatController.setIsReadTrue(message);
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollChatListToEnd();
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
                        }
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
                          } else
                          if (state == ChatPageState.manyMessagesSelected) {
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
              BlocBuilder<ChatPageCubit, ChatPageState>(builder: (context, state) {
                if (state == ChatPageState.onlyOneMessageSelected || state == ChatPageState.manyMessagesSelected) {
                  return IconButton(
                    onPressed: () {
                      if (state == ChatPageState.onlyOneMessageSelected || state == ChatPageState.manyMessagesSelected) {
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
              }),
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
                              value: 'Remove From Recent',
                              child: const Text('Remove From Recent'),
                              onTap: () {
                                _chatController.removeFromRecent();
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  SuccessSnackBar.show(context, 'Removed from recent chats.');
                                });
                              },
                            ),
                            PopupMenuItem<String>(
                              value: 'Secret Chat',
                              child: Row(
                                children: [
                                  const Text('Secret Chat'),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.2),
                                      borderRadius: const BorderRadius.all(Radius.circular(10))
                                    ),
                                    child: const Text('beta', style: TextStyle(color: Colors.blue)),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  Navigator.popAndPushNamed(context, Routes.secretChat, arguments: {
                                    'user': widget.user,
                                  });
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
              if (_chatController.isInitialized)
                Expanded(
                  flex: 1,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _chatController.listenMessageSignal(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Chats(label: 'Your chats are encrypted and secured on cloud.');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Loading();
                      }

                      List<MessageModel> messages = snapshot.data!.docs.map((doc) => MessageModel.fromJson(doc.data() as Map<String, dynamic>)).toList();

                      if (messages.isEmpty) {
                        return const Chats(label: 'Your chats are encrypted and secured on cloud.');
                      }

                      return GroupedListView<MessageModel, DateTime>(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        controller: _scrollController,
                        elements: messages,
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
                          return Container(
                            decoration: BoxDecoration(color: message.isSelected! ? Colors.blue.shade50 : null),
                            child: Message(
                              key: Key(message.id.toString()),
                              message: message,
                              sameUser: authState.uid == message.senderUid,
                              chatController: _chatController,
                              onSelect: (isSelected) {
                                if(isSelected || _chatController.selectedMessages.isNotEmpty) {
                                  BlocProvider.of<ChatPageCubit>(context).setMessagesSelected(_chatController.selectedMessages.length);
                                } else {
                                  BlocProvider.of<ChatPageCubit>(context).setMessagesUnselected();
                                }
                              },
                            ),
                          );
                        },
                      );
                    }
                  ),
                ),

              /// divider
              const Divider(),

              /// Message Sender
              Container(
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
                        onTapOutside: (pointer) {
                          _chatController.changeStatus('online');
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await _sendMessage();
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
    super.dispose();
  }
}
