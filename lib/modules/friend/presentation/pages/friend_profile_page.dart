import 'package:chatdrop/modules/friend/presentation/cubit/block_user/block_user_cubit.dart';
import 'package:chatdrop/modules/friend/presentation/cubit/block_user/block_user_state.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:chatdrop/shared/tools/avatar_image_provider.dart';
import 'package:chatdrop/shared/tools/snackbar_message.dart';
import 'package:chatdrop/shared/widgets/cover_photo_container.dart';
import 'package:chatdrop/shared/widgets/messages.dart';
import 'package:chatdrop/shared/illustrations/private.dart';
import 'package:chatdrop/shared/widgets/profile_fan_following.dart';
import 'package:chatdrop/shared/widgets/profile_name.dart';
import 'package:chatdrop/shared/widgets/profile_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/appbar_title.dart';
import '../../../../shared/models/friend_profile_model/friend_profile_model.dart';
import '../bloc/friend/friend_bloc.dart';
import '../bloc/friend/friend_event.dart';
import '../bloc/friend/friend_state.dart';
import '../widgets/friend_profile_sections.dart';

/// Profile Page for Viewing other user Profile
class FriendProfilePage extends StatefulWidget {
  final String uid;

  const FriendProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<FriendProfilePage> createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends State<FriendProfilePage> {
  late ThemeState theme;

  @override
  void initState() {
    theme = BlocProvider.of<ThemeCubit>(context).state;
    /// Fetching Profile
    BlocProvider.of<FriendBloc>(context).add(FriendProfileFetchEvent(widget.uid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<FriendBloc, FriendState>(
          builder: (context, state) {
            if (state is FriendProfileSuccessState) {
              FriendProfileModel profileModel = state.profileModel;
              return AppBarTitle(title: profileModel.profile?.username as String);
            }
            return const AppBarTitle(title: 'Profile');
          }
        ),
        actions: [
          BlocBuilder<FriendBloc, FriendState>(
            builder: (context, state) {
              if (state is FriendProfileSuccessState) {
                FriendProfileModel profileModel = state.profileModel;

                if (profileModel.isBlocked != null) {
                  return BlocProvider(
                    create: (context) => BlockUserCubit(profileModel.isBlocked!),
                    child: BlocBuilder<BlockUserCubit, BlockUserState>(
                        builder: (context, state) {
                          return PopupMenuButton(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.blue,
                            ),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem<String>(
                                  value: state == BlockUserState.block ? 'Unblock' : 'Block',
                                  child: Text(state == BlockUserState.block ? 'Unblock' : 'Block'),
                                  onTap: () {
                                    if(state == BlockUserState.block) {
                                      BlocProvider.of<BlockUserCubit>(context).unblockUser(profileModel.profile!.uid!);
                                    } else if (state == BlockUserState.unblock){
                                      BlocProvider.of<BlockUserCubit>(context).blockUser(profileModel.profile!.uid!);
                                    }
                                  },
                                ),
                                PopupMenuItem<String>(
                                  value: 'Report',
                                  child: const Text('Report'),
                                  onTap: () {
                                    Future.delayed(const Duration(milliseconds: 500), () {
                                      Navigator.pushNamed(context, Routes.reportUser, arguments: {
                                        'uid': profileModel.profile!.uid!
                                      });
                                    });
                                  },
                                ),
                              ];
                            },
                          );
                        }
                    ),
                  );
                }
              }
              return const SizedBox(width: 0, height: 0);
            }
          ),
        ],
      ),

      /// Friend Bloc Builder
      body: BlocConsumer<FriendBloc, FriendState>(
        builder: (context, state) {
          if (state is FriendProfileLoadingState ||
              state is FriendInitialState) {
            return const ProfileShimmerLoading();
          } else if (state is FriendProfileFailedState) {
            return ErrorMessage(message: state.error);
          } else if (state is FriendProfileSuccessState) {
            FriendProfileModel profileModel = state.profileModel;

            /// Add Friend Button States
            String friendBtnText = 'Add Friend';
            IconData friendBtnIcon = Icons.person_add_alt_1_rounded;
            if (profileModel.isFriend != null && profileModel.isFriend!) {
              friendBtnText = 'Unfriend';
              friendBtnIcon = Icons.person_remove_alt_1_rounded;
            } else if (profileModel.isFriendRequested != null && profileModel.isFriendRequested!) {
              friendBtnText = 'Accept Request';
              friendBtnIcon = Icons.check;
            }

            /// Follow Friend Button States
            String followBtnText = 'Follow';
            IconData followBtnIcon = Icons.favorite_border;
            if (profileModel.isFollowing != null && profileModel.isFollowing!) {
              followBtnText = 'Unfollow';
              followBtnIcon = Icons.favorite;
            }

            /// Scrollable Profile
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  /// Profile Photos
                  Stack(
                    children: [
                      /// Shows Cover Photo
                      CoverPhotoContainer(
                        coverPhotoUrl: profileModel.profile?.coverPhoto,
                      ),

                      /// Shows Circular Avatar as profile pic
                      Container(
                        alignment: Alignment.topCenter,
                        margin: const EdgeInsets.only(top: 80),
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: theme == ThemeState.light ? Colors.white: Colors.black,
                          child: CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.grey,
                            backgroundImage: Avatar.getAvatarProvider(
                              profileModel.profile?.gender as String,
                              profileModel.profile?.photo,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// Shows Profile Name
                  ProfileName(
                    name: profileModel.profile?.name as String,
                    message: profileModel.profile?.message as String,
                  ),

                  /// Profile Fan Following
                  const SizedBox(height: 10),
                  ProfileFanFollowing(
                    followers: profileModel.profile?.followerCount as int,
                    followings: profileModel.profile?.followingCount as int,
                    posts: profileModel.profile?.postCount as int,
                    reels: profileModel.profile?.reelCount as int,
                    onFollowersPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.followers,
                        arguments: {'uid': profileModel.profile!.uid},
                      );
                    },
                    onFollowingsPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.followings,
                        arguments: {'uid': profileModel.profile!.uid},
                      );
                    },
                    onPostsPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.postList,
                        arguments: {'uid': profileModel.profile!.uid},
                      );
                    },
                    onReelsPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.reelList,
                        arguments: {'uid': profileModel.profile!.uid},
                      );
                    },
                  ),

                  /// Friend, Follow and More Options if and only if profile and logged in user are different
                  const SizedBox(height: 10),
                  if (profileModel.isFriend != null || profileModel.isFollowing != null || profileModel.isFriendRequested != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Add Friend Button
                        ElevatedButton.icon(
                          icon: Icon(friendBtnIcon),
                          label: Text(friendBtnText),
                          onPressed: () {
                            if (profileModel.isFriend!) {
                              /// Removing Friend
                              BlocProvider.of<FriendBloc>(context).add(
                                UnfriendEvent(
                                  uid: widget.uid,
                                  friendProfile: profileModel,
                                ),
                              );
                            } else if (profileModel.isFriendRequested!) {
                              /// Accepting Friend Request
                              BlocProvider.of<FriendBloc>(context).add(
                                FriendRequestAcceptedEvent(
                                  requestId: profileModel.friendRequestId!,
                                  friendProfile: profileModel,
                                ),
                              );
                            } else {
                              /// Sending Friend Request
                              BlocProvider.of<FriendBloc>(context).add(
                                SendFriendRequestEvent(
                                  uid: widget.uid,
                                  friendProfile: profileModel,
                                ),
                              );
                            }
                          },
                        ),

                        /// Follow Request Sent Button or Unfollow Button
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          icon: Icon(followBtnIcon, color: Colors.white),
                          label: Text(followBtnText, style: const TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            if (profileModel.isFollowing!) {
                              /// Unfollowing Friend
                              BlocProvider.of<FriendBloc>(context).add(
                                UnfollowFriendEvent(
                                  uid: widget.uid,
                                  friendProfile: profileModel,
                                ),
                              );
                            } else {
                              /// Send Follow Request
                              BlocProvider.of<FriendBloc>(context).add(
                                SendFollowRequestEvent(
                                  uid: widget.uid,
                                  friendProfile: profileModel,
                                ),
                              );
                            }
                          },
                        ),

                        /// Follow Request accept Button
                        const SizedBox(width: 10),
                        if(profileModel.isFollowRequested!)
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check, color: Colors.white),
                            label: const Text('Accept', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              if(profileModel.isFollowRequested!) {
                                /// Accepting Follow Request
                                BlocProvider.of<FriendBloc>(context).add(
                                  AcceptFollowRequestEvent(
                                    requestId: profileModel.followRequestId!,
                                    friendProfile: profileModel,
                                  ),
                                );
                              }
                            },
                          ),
                      ],
                    ),

                  /// Profile Sections for about, post, photos and cover photos.
                  if (!profileModel.profile!.settings!.isProfilePrivate!)
                    BlocProvider.value(
                      value: BlocProvider.of<FriendBloc>(context),
                      child: FriendProfileSections(model: profileModel),
                    ),
                  if (profileModel.profile!.settings!.isProfilePrivate!)
                    Container(
                      margin: const EdgeInsets.only(top: 100),
                      child: const Private(label: 'This profile is private.'),
                    ),
                ],
              ),
            );
          } else {
            return const ErrorMessage(message: 'Something went wrong.');
          }
        },
        listener: (context, friendState) {
          if (friendState is FriendProfileFailedState) {
            ErrorSnackBar.show(context, friendState.error);
          } else if (friendState is FriendRemovedState) {
            SuccessSnackBar.show(context, 'You break the friendship.');
          } else if (friendState is FriendRequestSentState) {
            SuccessSnackBar.show(context, 'Friend request sent.');
          } else if (friendState is FriendRequestAcceptedState) {
            SuccessSnackBar.show(context, 'You are friends now.');
          } else if (friendState is FriendFollowRequestAcceptedState) {
            SuccessSnackBar.show(context, 'Follow request accepted.');
          } else if (friendState is FriendFollowRequestSentState) {
            SuccessSnackBar.show(context, 'Follow request sent.');
          } else if (friendState is FriendUnfollowedState) {
            SuccessSnackBar.show(context, 'You unfollow.');
          }
        },
      ),
    );
  }
}
