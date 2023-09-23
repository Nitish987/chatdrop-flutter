import 'dart:io';

import 'package:chatdrop/shared/widgets/bottom_sheet_container.dart';
import 'package:chatdrop/shared/widgets/friend_user_action_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controllers/normal_chat_controller.dart';
import '../cubit/my_friend_list/my_friend_list_cubit.dart';
import '../cubit/my_friend_list/my_friend_list_state.dart';
import '../illustrations/nothing.dart';
import '../models/message_model/message_model.dart';
import '../models/user_model/user_model.dart';
import 'list_tile_shimmer_loading.dart';

class MessageForwardOptionSheet extends StatelessWidget {
  const MessageForwardOptionSheet({Key? key, required this.contentType, this.content = '', this.refer = '', this.attachment}) : super(key: key);
  final String contentType;
  final String content;
  final String refer;
  final File? attachment;

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      height: 500,
      padding: const EdgeInsets.only(top: 10),
      children: [
        BlocProvider(
          create: (_) => MyFriendListCubit(),
          child: BlocBuilder<MyFriendListCubit, MyFriendListState>(
            builder: (context, state) {
              if (state is MyFriendListedState) {
                List<UserModel> friends = state.friends;

                if (friends.isEmpty) {
                  return const Nothing(label: 'No friends found.');
                }

                return Flexible(
                  child: ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      UserModel user = friends[index];
                      return FriendUserActionTile(
                        user: user,
                        label: 'Send',
                        onAction: (Function setProcessState) {
                          setProcessState(true);
                          NormalChatController chatController = NormalChatController();
                          chatController.init(user);
                          if (contentType == 'IMAGE' || contentType == 'VIDEO') {
                            final filename = attachment!.path.split('/').last;
                            chatController.uploadMessageAttachment(filename, attachment!.readAsBytesSync()).then((content) {
                              chatController.sendMessage(
                                MessageModel(
                                  contentType: contentType,
                                  content: content,
                                  time: DateTime.now().millisecondsSinceEpoch,
                                ),
                              );
                              setProcessState(false);
                            });
                          } else {
                            chatController.sendMessage(
                              MessageModel(
                                contentType: contentType,
                                content: content,
                                refer: refer,
                                time: DateTime.now().millisecondsSinceEpoch,
                              ),
                            );
                            setProcessState(false);
                          }
                        },
                      );
                    },
                  ),
                );
              } else {
                return const Flexible(child: ListTileShimmerLoading());
              }
            },
          ),
        ),
      ],
    );
  }
}
