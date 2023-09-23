import 'dart:convert';

import 'package:chatdrop/modules/dashboard/data/models/recent_chat_model/recent_chat_model.dart';
import 'package:chatdrop/modules/dashboard/presentation/bloc/recent_chats/recent_chats_bloc.dart';
import 'package:chatdrop/modules/dashboard/presentation/bloc/recent_chats/recent_chats_event.dart';
import 'package:chatdrop/modules/dashboard/presentation/bloc/recent_chats/recent_chats_state.dart';
import 'package:chatdrop/modules/dashboard/presentation/controllers/recent_chats_controller.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/cubit/auth/auth_cubit.dart';
import 'package:chatdrop/shared/cubit/auth/auth_state.dart';
import 'package:chatdrop/shared/models/message_model/secret_message_model.dart';
import 'package:chatdrop/shared/models/recent_secret_chat_model/recent_secret_chat_model.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:chatdrop/shared/tools/avatar_image_provider.dart';
import 'package:chatdrop/shared/widgets/list_tile_shimmer_loading.dart';
import 'package:chatdrop/shared/widgets/messages.dart';
import 'package:chatdrop/shared/illustrations/nothing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({Key? key}) : super(key: key);

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final RecentChatsController _recentChatsController = RecentChatsController();
  late int _switchTab = 0;

  /// push to secret chat page
  void pushToSecretChatPage(UserModel? user) async {
    if (user != null) {
      await Navigator.pushNamed(
        context,
        Routes.secretChat,
        arguments: {'user': user},
      );
      if(mounted) {
        // loads recent chats when user comes back to chats tab
        loadRecentChats();
      }
    }
  }

  /// push to chat page
  void pushToChatPage(UserModel? user) async {
    if (user != null) {
      await Navigator.pushNamed(
        context,
        Routes.normalChat,
        arguments: {'user': user},
      );
    }
  }

  Future<void> _pickFriend(String uid) async {
    UserModel? user = await Navigator.pushNamed(
      context,
      Routes.myFriendList,
      arguments: {'uid': uid},
    ) as UserModel?;
    pushToChatPage(user);
  }

  /// loads recent chats
  void loadRecentChats() {
    BlocProvider.of<RecentChatsBloc>(context).add(ListRecentChatsEvent());
  }

  @override
  void initState() {
    super.initState();
    loadRecentChats();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthState>(
        builder: (context, authState) {
      if (authState is Authenticated) {
        return Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  /// tabs
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _switchTab = 0;
                          });
                        },
                        child: Chip(
                          label: Text('recent chats', style: TextStyle(color: _switchTab == 0 ? Colors.white : Colors.blue)),
                          backgroundColor: _switchTab == 0 ? Colors.blue : null,
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _switchTab = 1;
                            loadRecentChats();
                          });
                        },
                        child: Chip(
                          label: Text('secret chats - beta', style: TextStyle(color: _switchTab == 1 ? Colors.white : Colors.blue)),
                          backgroundColor: _switchTab == 1 ? Colors.blue : null,
                        ),
                      ),
                    ],
                  ),

                  if (_switchTab == 0)
                  /// listing recent chats
                    StreamBuilder(
                      stream: _recentChatsController.streamRecentChats(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Nothing(label: 'No recent chats', margin: EdgeInsets.only(top: 200));
                        }

                        List<RecentChatModel> recentChats = snapshot.data!.docs.map((r) => RecentChatModel.fromJson(r.data())).toList();

                        if (recentChats.isEmpty) {
                          return const Nothing(label: 'No recent chats', margin: EdgeInsets.only(top: 200));
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: recentChats.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            RecentChatModel model = recentChats[index];

                            String text = 'new message for you';
                            if (model.message != null) {
                              if (model.message!.contentType == 'IMAGE') {
                                text = 'photo';
                              } else if(model.message!.contentType == 'VIDEO') {
                                text = 'video';
                              } else {
                                text = _recentChatsController.decryptContent(model.message!.content!);
                              }
                            }

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: Avatar.getAvatarProvider(
                                  model.gender!,
                                  model.photo,
                                ),
                              ),
                              title: Text(model.name!),
                              subtitle: Text(
                                text,
                                maxLines: 1,
                                style: model.message!.isRead! ? null : const TextStyle(color: Colors.blue),
                              ),
                              trailing: Text(
                                DateFormat.yMMMd().format(
                                  DateTime.fromMillisecondsSinceEpoch(model.time!),
                                ),
                                maxLines: 1,
                                style: model.message!.isRead! ? null : const TextStyle(color: Colors.blue),
                              ),
                              onTap: () {
                                _recentChatsController.setIsReadTrue(model.message!, model.uid!);
                                UserModel user = UserModel(
                                  uid: model.uid,
                                  name: model.name,
                                  photo: model.photo,
                                  gender: model.gender,
                                  chatroom: model.chatroom,
                                );
                                pushToChatPage(user);
                              },
                            );
                          },
                        );
                      },
                    ),


                  if (_switchTab == 1)
                  /// listing recent secret chats
                    BlocBuilder<RecentChatsBloc, RecentChatsState>(
                      builder: (context, state) {
                        if (state is RecentChatsListState) {
                          List<RecentSecretChatModel> recentChats = state.recentChats;

                          if (recentChats.isEmpty) {
                            return const Nothing(label: 'No recent chats', margin: EdgeInsets.only(top: 200));
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: recentChats.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              RecentSecretChatModel model = recentChats[index];

                              String text = 'new message for you';
                              if (model.message != null) {
                                if (model.message!.contentType == 'IMAGE') {
                                  text = 'image';
                                } else if(model.message!.contentType == 'VIDEO') {
                                  text = 'video';
                                } else {
                                  if (model.message!.isInterrupted!) {
                                    text = '...';
                                  } else {
                                    SecretMessageContentModel messageContent = SecretMessageContentModel.fromJson(jsonDecode(model.message!.content!));
                                    text = messageContent.text!;
                                  }
                                }
                              }

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: Avatar.getAvatarProvider(
                                    model.recent!.gender!,
                                    model.recent!.photo,
                                  ),
                                ),
                                title: Text(model.recent!.name!),
                                subtitle: Text(
                                  text,
                                  maxLines: 1,
                                  style: model.message!.isRead! ? null : const TextStyle(color: Colors.blue),
                                ),
                                trailing: Text(
                                  DateFormat.yMMMd().format(
                                    DateTime.fromMillisecondsSinceEpoch(model.message!.time!),
                                  ),
                                  maxLines: 1,
                                  style: model.message!.isRead! ? null : const TextStyle(color: Colors.blue),
                                ),
                                onTap: () {
                                  UserModel user = UserModel(
                                    uid: model.recent!.chatWith,
                                    name: model.recent!.name,
                                    photo: model.recent!.photo,
                                    gender: model.recent!.gender,
                                  );
                                  pushToSecretChatPage(user);
                                },
                              );
                            },
                          );
                        }
                        return const ListTileShimmerLoading();
                      },
                    ),
                ],
              ),
            ),

            /// Friend List Button
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 162,
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.aiChat);
                      },
                      heroTag: 'Ai',
                      child: const Text('Ai', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),
                    FloatingActionButton(
                      onPressed: () {
                        _pickFriend(authState.uid);
                      },
                      heroTag: 'Friends',
                      child: const Icon(Icons.group_outlined),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }
      return const ErrorMessage(message: 'Please login again.');
    });
  }
}
