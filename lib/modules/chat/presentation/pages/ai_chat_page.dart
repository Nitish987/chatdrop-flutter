import 'package:chatdrop/modules/chat/presentation/bloc/ai_chat/ai_chat_bloc.dart';
import 'package:chatdrop/modules/chat/presentation/bloc/ai_chat/ai_chat_event.dart';
import 'package:chatdrop/modules/chat/presentation/bloc/ai_chat/ai_chat_state.dart';
import 'package:chatdrop/modules/chat/presentation/controllers/ai_chat_controller.dart';
import 'package:chatdrop/modules/chat/presentation/cubit/chatting_status/chatting_status_cubit.dart';
import 'package:chatdrop/modules/chat/presentation/cubit/chatting_status/chatting_status_state.dart';
import 'package:chatdrop/modules/chat/presentation/widgets/ai_message.dart';
import 'package:chatdrop/shared/cubit/auth/auth_cubit.dart';
import 'package:chatdrop/shared/cubit/auth/auth_state.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:chatdrop/shared/illustrations/chats.dart';
import 'package:chatdrop/modules/chat/data/models/message_model/ai_message_model.dart';
import 'package:chatdrop/shared/widgets/loading.dart';
import 'package:chatdrop/shared/widgets/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../cubit/chat_page/chat_page_cubit.dart';
import '../cubit/chat_page/chat_page_state.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  late ThemeState theme;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiChatController _chatController = AiChatController();

  /// sends the message and gets the instance generative reply from ai
  void _sendMessage(String senderUid) {
    if (_messageController.value.text.isNotEmpty) {
      changeStatus('typing');
      int time = DateTime.now().millisecondsSinceEpoch;
      final senderMessage = AiMessageModel(
        id: time,
        senderUid: senderUid,
        contentType: 'TEXT',
        content: _messageController.value.text,
        time: time,
      );
      BlocProvider.of<AiChatBloc>(context).add(AddAiMessageEvent(senderMessage));
      _scrollChatListToEnd();
      _chatController.replyForMessage(senderMessage).then((aiMessage) {
        BlocProvider.of<AiChatBloc>(context).add(AddAiMessageEvent(aiMessage));
        _scrollChatListToEnd();
        changeStatus('online');
      });
      _messageController.text = '';
    }
  }

  /// change status such as online, offline or typing
  void changeStatus(String status) {
    BlocProvider.of<ChattingStatusCubit>(context).updateStatus(status);
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

  @override
  void initState() {
    theme = BlocProvider.of<ThemeCubit>(context).state;
    _chatController.initialize().then((value) {
      _chatController.retrieveMessages().then((messages) {
        BlocProvider.of<AiChatBloc>(context).add(AiChatListEvent(messages));
        Future.delayed(const Duration(milliseconds: 300), () {
          _scrollChatListToEnd();
        });
      });
    });
    changeStatus('online');
    super.initState();
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
                const CircleAvatar(
                  radius: 20,
                  child: Text('Ai', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Olivia Ai',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      BlocBuilder<ChattingStatusCubit, ChattingStatusState>(
                        builder: (context, state) {
                          return Text(
                            state.name.toString(),
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
              BlocBuilder<ChatPageCubit, ChatPageState>(builder: (context, state) {
                if (state == ChatPageState.onlyOneMessageSelected || state == ChatPageState.manyMessagesSelected) {
                  return IconButton(
                    onPressed: () {
                      _chatController.deleteMessages().then((value) {
                        BlocProvider.of<AiChatBloc>(context).add(DeleteAiMessageEvent(_chatController.selectedMessages));
                        Future.delayed(const Duration(milliseconds: 300), () {
                          BlocProvider.of<ChatPageCubit>(context).setMessagesUnselected();
                        });
                      });
                    },
                    icon: const Icon(Icons.delete_outline),
                  );
                }
                return const SizedBox();
              }),
            ],
          ),
          body: Column(
            children: [
              /// Chats List
              const SizedBox(height: 1),
              Expanded(
                flex: 1,
                child: BlocBuilder<AiChatBloc, AiChatState>(
                  builder: (context, state) {
                    if (state is AiChatListState) {
                      List<AiMessageModel> messages = state.messages;

                      if (messages.isEmpty) {
                        return const Chats(label: 'Hello! I am Olivia, feel free to ask anything.');
                      }

                      return GroupedListView<AiMessageModel, DateTime>(
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
                          return const SizedBox(height: 5);},
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
                          );},
                        itemBuilder: (context, message) {
                          return Container(
                            decoration: BoxDecoration(color: message.isSelected! ? Colors.blue.shade50 : null),
                            child: AiMessage(
                              key: Key(message.id.toString()),
                              message: message,
                              sameUser: authState.uid == message.senderUid,
                              chatController: _chatController,
                              onSelect: (isSelected) {
                                if(isSelected || _chatController.selectedMessages.isNotEmpty) {
                                  BlocProvider.of<ChatPageCubit>(context).setMessagesSelected(_chatController.selectedMessages.length);
                                } else {
                                  BlocProvider.of<ChatPageCubit>(context).setMessagesUnselected();
                                }},
                            ),
                          );
                        },
                      );
                    } else if (state is LoadingAiChatListState) {
                      return const Loading();
                    } else if (state is InitialAiChatState) {
                      return const Chats(label: 'Hello! I am Olivia, feel free to ask anything.');
                    } else {
                      return const ErrorMessage(message: 'Unable to load Chats.');
                    }
                  },
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.auto_awesome,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 10),
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
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        _sendMessage(authState.uid);
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
    _chatController.dispose();
    super.dispose();
  }
}
