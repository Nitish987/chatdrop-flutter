import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/modules/post/presentation/cubit/post_comment_delete/post_comment_delete_cubit.dart';
import 'package:chatdrop/modules/post/presentation/cubit/post_comment_delete/post_comment_delete_state.dart';
import 'package:chatdrop/modules/post/presentation/cubit/post_comment_like/post_comment_like_cubit.dart';
import 'package:chatdrop/modules/post/presentation/cubit/post_comment_like/post_comment_like_state.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:chatdrop/shared/models/post_comment_model/post_comment_model.dart';
import 'package:chatdrop/shared/tools/avatar_image_provider.dart';
import 'package:chatdrop/modules/post/presentation/widgets/post_comment_option_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostComment extends StatelessWidget {
  const PostComment({Key? key, required this.comment, required this.sameUser}) : super(key: key);

  final PostCommentModel comment;
  final bool sameUser;

  @override
  Widget build(BuildContext context) {
    ThemeState theme = BlocProvider.of<ThemeCubit>(context).state;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PostCommentLikeCubit(comment.liked)),
        BlocProvider(create: (_) => PostCommentDeleteCubit()),
      ],
      child: BlocBuilder<PostCommentDeleteCubit, PostCommentDeleteState>(
          builder: (context, state) {
        if (state is PostCommentDeletedState) {
          return Container();
        }
        return Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),

                /// Profile Pic
                leading: InkWell(
                  child: CircleAvatar(
                    radius: 17,
                    backgroundImage: Avatar.getAvatarProvider(
                        comment.user!.gender.toString(),
                        comment.user!.photo.toString()),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.friendProfile,
                      arguments: {'uid': comment.user!.uid},
                    );
                  },
                ),

                /// Name
                title: Text(
                  comment.user!.name.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                /// Comment Text
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Text(
                    comment.text.toString(),
                  ),
                ),

                /// more option button
                trailing: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => PostCommentOptionSheet(
                        sameUser: sameUser,
                        onDelete: () {
                          BlocProvider.of<PostCommentDeleteCubit>(context).deletePostComment(
                            comment.postId.toString(),
                            comment.id.toString(),
                          );
                        },
                        onReport: () {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.pushNamed(context, Routes.reportUser, arguments: {
                              'uid': comment.user!.uid!
                            });
                          });
                        },
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.more_horiz,
                    color: theme == ThemeState.light ? Colors.black : Colors.white,
                  ),
                ),
              ),

              /// Likes and commented on date
              BlocBuilder<PostCommentLikeCubit, PostCommentLikeState>(
                  builder: (context, state) {
                /// configuring likes count
                int likesCount = comment.likesCount!;
                String likeText = '$likesCount ${(likesCount > 1) ? 'likes' : 'like'}';
                if (state is PostCommentLikedState) {
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
                  if (comment.liked != null) {
                    likeText = '${--likesCount} ${(likesCount > 1) ? 'likes' : 'like'}';
                  }
                }

                return Container(
                  padding: const EdgeInsets.only(left: 65),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            likeText,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            comment.commentedOn.toString(),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 10),
                          ),
                        ],
                      ),

                      /// Like button
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                          onPressed: () {
                            if (state is PostCommentLikedState) {
                              BlocProvider.of<PostCommentLikeCubit>(context).dislikePostComment(comment.id.toString());
                              comment.liked = null;
                              comment.likesCount = comment.likesCount! - 1;
                              if (comment.likesCount! < 0) {
                                comment.likesCount = 0;
                              }
                            } else {
                              BlocProvider.of<PostCommentLikeCubit>(context).likePostComment(
                                comment.id.toString(),
                                'LIKE',
                              );
                              comment.liked = 'LIKE';
                              comment.likesCount = comment.likesCount! + 1;
                            }
                          },
                          icon: (state is PostCommentLikedState)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(Icons.favorite_border),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const Divider(),
            ],
          ),
        );
      }),
    );
  }
}
