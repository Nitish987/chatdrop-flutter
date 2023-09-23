import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/controllers/post_video_controller.dart';
import 'package:chatdrop/shared/cubit/post_delete/post_delete_cubit.dart';
import 'package:chatdrop/shared/cubit/post_delete/post_delete_state.dart';
import 'package:chatdrop/shared/cubit/post_like/post_like_cubit.dart';
import 'package:chatdrop/shared/cubit/post_like/post_like_state.dart';
import 'package:chatdrop/shared/cubit/post_visibility/post_visibility_cubit.dart';
import 'package:chatdrop/shared/cubit/post_visibility/post_visibility_state.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:chatdrop/shared/models/post_model/post_model.dart';
import 'package:chatdrop/shared/tools/avatar_image_provider.dart';
import 'package:chatdrop/shared/widgets/message_forward_option_sheet.dart';
import 'package:chatdrop/shared/widgets/post_option_sheet.dart';
import 'package:chatdrop/shared/widgets/post_photo.dart';
import 'package:chatdrop/shared/widgets/post_text.dart';
import 'package:chatdrop/shared/widgets/post_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class Post extends StatefulWidget {
  const Post({Key? key, required this.post, required this.sameUser}) : super(key: key);
  final PostModel post;
  final bool sameUser;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  late ThemeState theme;
  final PostVideoController _videoController = PostVideoController();

  @override
  void initState() {
    super.initState();
    theme = BlocProvider.of<ThemeCubit>(context).state;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PostVisibilityCubit(widget.post.visibility!)),
        BlocProvider(create: (_) => PostLikeCubit(widget.post.liked)),
        BlocProvider(create: (_) => PostDeleteCubit()),
      ],
      child: BlocBuilder<PostDeleteCubit, PostDeleteState>(
        builder: (context, state) {
          if (state is PostDeletedState || widget.post.isDeleted!) {
            return Container();
          }
          return Container(
            padding: const EdgeInsets.only(bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// User Info Tile
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: Avatar.getAvatarProvider(
                        widget.post.user!.gender.toString(),
                        widget.post.user!.photo.toString(),
                    ),
                  ),
                  title: Text(widget.post.user!.name.toString()),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.post.postedOn.toString()),
                      const SizedBox(width: 5),
                      const Text('\u2022'),
                      const SizedBox(width: 5),
                      BlocBuilder<PostVisibilityCubit, PostVisibilityState>(builder: (context, state) {
                        IconData icon = Icons.public_outlined;
                        switch (state) {
                          case PostVisibilityState.public: icon = Icons.public_outlined; break;
                          case PostVisibilityState.onlyFriends: icon = Icons.people_outline; break;
                          case PostVisibilityState.private: icon = Icons.lock_outline; break;
                        }
                        return Icon(icon, size: 12, color: Colors.grey);
                      }),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      // pausing video
                      _videoController.autoStatePause();

                      // showing post options
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => PostOptionSheet(
                          sameUser: widget.sameUser,
                          onView: () {
                            // pausing video
                            _videoController.pause();

                            Future.delayed(const Duration(milliseconds: 500), () async {
                               Navigator.pushNamed(context, Routes.postShowcase, arguments: {
                                 'post': widget.post,
                                 'same_user': widget.sameUser,
                                 'post_visibility_cubit': BlocProvider.of<PostVisibilityCubit>(context),
                                 'post_like_cubit': BlocProvider.of<PostLikeCubit>(context),
                                 'post_delete_cubit': BlocProvider.of<PostDeleteCubit>(context),
                                });
                            });
                          },
                          onDelete: () {
                            // pausing video
                            _videoController.pause();

                            widget.post.isDeleted = true;
                            BlocProvider.of<PostDeleteCubit>(context).deletePost(
                              widget.post.id.toString(),
                            );
                          },
                          onReport: () {
                            // pausing video
                            _videoController.pause();

                            Future.delayed(const Duration(milliseconds: 500), () {
                              Navigator.pushNamed(context, Routes.reportUser, arguments: {
                                'uid': widget.post.user!.uid!
                              });
                            });
                          },
                        ),
                      ).then((value) {
                        _videoController.autoStatePlay();
                      });
                    },
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.friendProfile,
                      arguments: {'uid': widget.post.user!.uid},
                    );
                  },
                ),

                /// Text
                if (widget.post.contentType == 'TEXT' || widget.post.contentType == 'TEXT_PHOTO' || widget.post.contentType == 'TEXT_VIDEO')
                  PostText(
                    text: widget.post.text!,
                    containsHashtags: widget.post.containsHashtags!,
                    hashtags: widget.post.hashtags!,
                  ),

                /// Photo
                if (widget.post.contentType == 'PHOTO' || widget.post.contentType == 'TEXT_PHOTO')
                  PostPhotos(
                    photos: widget.post.photos!,
                  ),

                /// Video
                if (widget.post.contentType == "VIDEO" || widget.post.contentType == 'TEXT_VIDEO')
                  PostVideo(
                    id: widget.post.id.toString(),
                    video: widget.post.video!,
                    controller: _videoController,
                  ),

                /// Like, Comment and Share Container
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          /// Like
                          BlocBuilder<PostLikeCubit, PostLikeState>(
                            builder: (context, state) {
                              return IconButton(
                                onPressed: () {
                                  if (state is PostLikedState) {
                                    BlocProvider.of<PostLikeCubit>(context).dislikePost(widget.post.id.toString());
                                    widget.post.liked = null;
                                    widget.post.likesCount = widget.post.likesCount! - 1;
                                    if (widget.post.likesCount! < 0) {
                                      widget.post.likesCount = 0;
                                    }
                                  } else {
                                    BlocProvider.of<PostLikeCubit>(context).likePost(widget.post.id.toString(), 'LIKE');
                                    widget.post.liked = 'LIKE';
                                    widget.post.likesCount = widget.post.likesCount! + 1;
                                  }
                                },
                                icon: (state is PostLikedState)
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                    Icons.favorite_border,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),

                          /// Comment
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                Routes.postComment,
                                arguments: {
                                  'post_id': widget.post.id,
                                  'autofocus': false,
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.mode_comment_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      /// Forward
                      IconButton(
                        onPressed: () {
                          _videoController.autoStatePause();

                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return MessageForwardOptionSheet(
                                contentType: 'POST',
                                content: 'Post by ${widget.post.user!.name!}',
                                refer: widget.post.id!,
                              );
                            }
                          ).then((value) {
                            _videoController.autoStatePlay();
                          });
                        },
                        icon: const Icon(
                          Icons.send_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Likes count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: BlocBuilder<PostLikeCubit, PostLikeState>(
                    builder: (context, state) {
                      /// configuring likes count
                      int likesCount = widget.post.likesCount!;
                      String likeText = '$likesCount ${(likesCount > 1) ? 'likes' : 'like'}';
                      if (state is PostLikedState) {
                        switch (likesCount) {
                          case 1:
                            likeText = 'You like this';
                            break;
                          case 2:
                            likeText = 'Liked by you and one other';
                            break;
                          default:
                            likeText = 'Liked by you and ${likesCount - 1} others';
                            break;
                        }
                      } else {
                        if (widget.post.liked != null) {
                          likeText = '${--likesCount} ${(likesCount > 1) ? 'likes' : 'like'}';
                        }
                      }
                      return Text(
                        likeText,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),

                /// Comments Count
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.postComment,
                        arguments: {
                          'post_id': widget.post.id,
                          'autofocus': false,
                        },
                      );
                    },
                    child: Text(
                      'View all ${widget.post.commentsCount.toString()} comments',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                /// Comment Container
                InkWell(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: Avatar.getAvatarProvider(
                              widget.post.authUser!.gender.toString(),
                              widget.post.authUser!.photo.toString()),
                        ),
                        const Text(
                          '    Drop a comment',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.postComment,
                      arguments: {
                        'post_id': widget.post.id,
                        'autofocus': true,
                      },
                    );
                  },
                ),

                /// Divider
                const Divider(),
              ],
            ),
          );
        }
      ),
    );
  }
}
