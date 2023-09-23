import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/controllers/reel_controller.dart';
import 'package:chatdrop/shared/models/reel_model/reel_model.dart';
import 'package:chatdrop/shared/tools/avatar_image_provider.dart';
import 'package:chatdrop/shared/tools/snackbar_message.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../cubit/reel_delete/reel_delete_cubit.dart';
import '../cubit/reel_delete/reel_delete_state.dart';
import '../cubit/reel_like/reel_like_cubit.dart';
import '../cubit/reel_like/reel_like_state.dart';
import '../cubit/reel_visibility/reel_visibility_cubit.dart';
import '../cubit/reel_visibility/reel_visibility_state.dart';
import 'message_forward_option_sheet.dart';


class Reel extends StatefulWidget {
  const Reel({super.key, required this.reel, required this.sameUser});
  final ReelModel reel;
  final bool sameUser;

  @override
  State<Reel> createState() => _ReelState();
}

class _ReelState extends State<Reel> {
  final ReelController _reelController = ReelController();
  late VideoPlayerController _playerController;

  @override
  void initState() {
    _playerController = VideoPlayerController.networkUrl(Uri.parse(widget.reel.video!.url!))
    ..initialize().then((value) {
      _playerController.setLooping(true);
      _playerController.play();
      _reelController.giveReelView(widget.reel);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ReelVisibilityCubit(widget.reel.visibility!)),
        BlocProvider(create: (_) => ReelLikeCubit(widget.reel.liked)),
        BlocProvider(create: (_) => ReelDeleteCubit()),
      ],
      child: BlocBuilder<ReelDeleteCubit, ReelDeleteState>(
        builder: (context, state) {
          if (state is ReelDeletedState || widget.reel.isDeleted!) {
            return Container(
              color: Colors.black,
              child: const Center(
                child: Text(
                  'This Reel was deleted.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
          return Container(
            color: Colors.black,
            child: Stack(
              children: [
                /// video player
                if (_playerController.value.isInitialized)
                  Center(
                    child: Transform.scale(
                      scale: media.size.aspectRatio + 0.8,
                      child: AspectRatio(
                        aspectRatio: widget.reel.video!.aspectRatio!,
                        child: VideoPlayer(_playerController),
                      ),
                    ),
                  ),

                /// appbar options
                SafeArea(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          PopupMenuButton(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            itemBuilder: (context) {
                              ReelVisibilityState visibility = BlocProvider.of<ReelVisibilityCubit>(context).state;
                              String visibilityText = 'PUBLIC';
                              switch (visibility) {
                                case ReelVisibilityState.public: visibilityText = 'Make Only Friends'; break;
                                case ReelVisibilityState.onlyFriends: visibilityText = 'Make Private'; break;
                                case ReelVisibilityState.private: visibilityText = 'Make Public'; break;
                              }
                              return [
                                if (widget.sameUser)
                                  PopupMenuItem<String>(
                                    value: widget.reel.visibility,
                                    child: Text(visibilityText),
                                    onTap: () {
                                      switch(visibility) {
                                        case ReelVisibilityState.public:
                                          BlocProvider.of<ReelVisibilityCubit>(context).changeVisibility(widget.reel.id!, 'ONLY_FRIENDS');
                                          break;
                                        case ReelVisibilityState.onlyFriends:
                                          BlocProvider.of<ReelVisibilityCubit>(context).changeVisibility(widget.reel.id!, 'PRIVATE');
                                          break;
                                        case ReelVisibilityState.private:
                                          BlocProvider.of<ReelVisibilityCubit>(context).changeVisibility(widget.reel.id!, 'PUBLIC');
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
                                      _playerController.pause();

                                      widget.reel.isDeleted = true;
                                      BlocProvider.of<ReelDeleteCubit>(context).deleteReel(
                                        widget.reel.id.toString(),
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
                                    _playerController.pause();

                                    Future.delayed(const Duration(milliseconds: 500), () {
                                      Navigator.pushNamed(context, Routes.reportUser, arguments: {
                                        'uid': widget.reel.user!.uid!
                                      });
                                    }).then((value) {
                                      _playerController.play();
                                    });
                                  },
                                ),
                              ];
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// like, comment, share and visibility
                Positioned(
                  right: 0,
                  bottom: 140,
                  child: SizedBox(
                    width: 70,
                    height: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// like
                        Column(
                          children: [
                            BlocBuilder<ReelLikeCubit, ReelLikeState>(
                              builder: (context, state) {
                                return IconButton(
                                  onPressed: () {
                                    if (state is ReelLikedState) {
                                      BlocProvider.of<ReelLikeCubit>(context).dislikeReel(widget.reel.id.toString());
                                      widget.reel.liked = null;
                                      widget.reel.likesCount = widget.reel.likesCount! - 1;
                                      if (widget.reel.likesCount! < 0) {
                                        widget.reel.likesCount = 0;
                                      }
                                    } else {
                                      BlocProvider.of<ReelLikeCubit>(context).likeReel(widget.reel.id.toString(), 'LIKE');
                                      widget.reel.liked = 'LIKE';
                                      widget.reel.likesCount = widget.reel.likesCount! + 1;
                                    }
                                  },
                                  icon: (state is ReelLikedState)
                                      ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                      : const Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            ),
                            Text(
                              widget.reel.likesCount.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),

                        /// comment
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                _playerController.pause();
                                Navigator.pushNamed(context, Routes.reelComment, arguments: {
                                  'reel_id': widget.reel.id,
                                  'autofocus': false,
                                }).then((value) {
                                  _playerController.play();
                                });
                              },
                              icon: const Icon(Icons.comment_outlined, color: Colors.white),
                            ),
                            Text(
                              widget.reel.commentsCount.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),

                        /// share
                        IconButton(
                          onPressed: () {
                            _playerController.pause();

                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return MessageForwardOptionSheet(
                                    contentType: 'REEL',
                                    content: 'Reel by ${widget.reel.user!.name!}',
                                    refer: widget.reel.id!,
                                  );
                                }
                            ).then((value) {
                              _playerController.play();
                            });
                          },
                          icon: const Icon(Icons.share_outlined, color: Colors.white),
                        ),

                        /// visibility
                        BlocBuilder<ReelVisibilityCubit, ReelVisibilityState>(builder: (context, state) {
                          IconData icon = Icons.public_outlined;
                          switch (state) {
                            case ReelVisibilityState.public: icon = Icons.public_outlined; break;
                            case ReelVisibilityState.onlyFriends: icon = Icons.people_outline; break;
                            case ReelVisibilityState.private: icon = Icons.lock_outline; break;
                          }
                          return Icon(icon, color: Colors.white);
                        }),
                      ],
                    ),
                  ),
                ),

                /// reel information
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ListTile(
                          subtitle: Padding(
                            padding: const EdgeInsets.only(right: 100),
                            child: DetectableText(
                              detectionRegExp: detectionRegExp()!,
                              text: widget.reel.text!,
                              maxLines: 3,
                              detectedStyle: const TextStyle(color: Colors.white),
                              basicStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        if (widget.reel.video!.audio != null)
                          ListTile(
                            leading: const Icon(Icons.audiotrack, color: Colors.white),
                            title: Text(
                              widget.reel.video!.audio!.name!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.friendProfile, arguments: {
                              'uid': widget.reel.user!.uid!
                            });
                          },
                          leading: CircleAvatar(
                            backgroundImage: Avatar.getAvatarProvider(
                              widget.reel.user!.gender!,
                              widget.reel.user!.photo!
                            ),
                          ),
                          title: Text(
                            widget.reel.user!.name!,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            widget.reel.user!.username!,
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: (widget.reel.isFollowing! || widget.sameUser) ? null: ElevatedButton(
                            onPressed: () {
                              _reelController.follow(widget.reel.user!).then((value) {
                                SuccessSnackBar.show(context, 'Follow request sent.');
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text('Follow', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  @override
  void dispose() {
    try {
      _playerController.dispose();
    } catch(e) {
      debugPrint('Video Controller Initialized to Dispose');
    }
    super.dispose();
  }
}

