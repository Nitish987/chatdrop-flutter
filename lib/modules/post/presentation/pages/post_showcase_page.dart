import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/controllers/post_video_controller.dart';
import 'package:chatdrop/shared/widgets/message_forward_option_sheet.dart';
import 'package:chatdrop/shared/widgets/post_photo.dart';
import 'package:chatdrop/shared/widgets/post_text.dart';
import 'package:chatdrop/shared/widgets/post_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/post_delete/post_delete_cubit.dart';
import '../../../../shared/cubit/post_like/post_like_cubit.dart';
import '../../../../shared/cubit/post_like/post_like_state.dart';
import '../../../../shared/cubit/post_visibility/post_visibility_cubit.dart';
import '../../../../shared/cubit/post_visibility/post_visibility_state.dart';
import '../../../../shared/cubit/theme/theme_cubit.dart';
import '../../../../shared/models/post_model/post_model.dart';
import '../../../../shared/cubit/theme/theme_state.dart';
import '../../../../shared/tools/avatar_image_provider.dart';

class PostShowcasePage extends StatefulWidget {
  final bool sameUser;
  final PostModel post;
  const PostShowcasePage({Key? key, required this.post, required this.sameUser}) : super(key: key);

  @override
  State<PostShowcasePage> createState() => _PostShowcasePageState();
}

class _PostShowcasePageState extends State<PostShowcasePage> {
  late ThemeState theme;
  final PostVideoController _videoController = PostVideoController();

  @override
  void initState() {
    super.initState();
    theme = BlocProvider.of<ThemeCubit>(context).state;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.friendProfile,
              arguments: {'uid': widget.post.user!.uid},
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: Avatar.getAvatarProvider(
                  widget.post.user!.gender.toString(),
                  widget.post.user!.photo,
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
                      widget.post.user!.name.toString(),
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.post.postedOn.toString(),
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          '\u2022',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12
                          ),
                        ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.blue,
            ),
            itemBuilder: (context) {
              PostVisibilityState visibility = BlocProvider.of<PostVisibilityCubit>(context).state;
              String visibilityText = 'PUBLIC';
              switch (visibility) {
                case PostVisibilityState.public: visibilityText = 'Make Only Friends'; break;
                case PostVisibilityState.onlyFriends: visibilityText = 'Make Private'; break;
                case PostVisibilityState.private: visibilityText = 'Make Public'; break;
              }
              return [
                if (widget.sameUser)
                  PopupMenuItem<String>(
                    value: widget.post.visibility,
                    child: Text(visibilityText),
                    onTap: () {
                      switch(visibility) {
                        case PostVisibilityState.public:
                          BlocProvider.of<PostVisibilityCubit>(context).changeVisibility(widget.post.id!, 'ONLY_FRIENDS');
                          break;
                        case PostVisibilityState.onlyFriends:
                          BlocProvider.of<PostVisibilityCubit>(context).changeVisibility(widget.post.id!, 'PRIVATE');
                          break;
                        case PostVisibilityState.private:
                          BlocProvider.of<PostVisibilityCubit>(context).changeVisibility(widget.post.id!, 'PUBLIC');
                          break;
                      }
                    },
                  ),
                if (widget.sameUser)
                  PopupMenuItem<String>(
                    value: 'Delete',
                    child: const Text('Delete'),
                    onTap: () {
                      // pausing video
                      _videoController.pause();

                      BlocProvider.of<PostDeleteCubit>(context).deletePost(
                        widget.post.id.toString(),
                      );
                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.pop(context);
                      });
                    },
                  ),
                PopupMenuItem<String>(
                  value: 'Report',
                  child: const Text('Report'),
                  onTap: () {
                    // pausing video
                    _videoController.pause();

                    Future.delayed(const Duration(milliseconds: 500), () {
                      Navigator.pushNamed(context, Routes.reportUser, arguments: {
                        'uid': widget.post.user!.uid!
                      });
                    });
                  },
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
              ],
            ),
          ),
        ],
      ),
      bottomSheet: SizedBox(
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
              padding: const EdgeInsets.only(left: 20, bottom: 10),
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
          ],
        ),
      ),
    );
  }
}
