import 'package:chatdrop/shared/cubit/auth/auth_cubit.dart';
import 'package:chatdrop/shared/cubit/auth/auth_state.dart';
import 'package:chatdrop/shared/models/reel_comment_model/reel_comment_model.dart';
import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:chatdrop/shared/widgets/list_tile_shimmer_loading.dart';
import 'package:chatdrop/shared/widgets/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/reel_comment/reel_comment_bloc.dart';
import '../bloc/reel_comment/reel_comment_event.dart';
import '../bloc/reel_comment/reel_comment_state.dart';
import '../widgets/reel_comment.dart';

class ReelCommentPage extends StatefulWidget {
  final String reelId;
  final bool autofocus;

  const ReelCommentPage({Key? key, required this.reelId, required this.autofocus}) : super(key: key);

  @override
  State<ReelCommentPage> createState() => _ReelCommentPageState();
}

class _ReelCommentPageState extends State<ReelCommentPage> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _commentListScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ReelCommentBloc>(context)
        .add(FetchReelCommentEvent(widget.reelId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthState>(
        builder: (context, authState) {
          if (authState is Authenticated) {
            return Scaffold(
              appBar: AppBar(
                title: const AppBarTitle(title: 'Reel Comments'),
              ),
              body: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocConsumer<ReelCommentBloc, ReelCommentState>(
                      builder: (context, state) {
                        if (state is FetchedReelCommentState) {
                          List<ReelCommentModel> comments = state.comments;

                          if (comments.isEmpty) {
                            return Flexible(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.8,
                                child: const CenterMessage(
                                  message:
                                  'No comments are there. Be the first to comment.',
                                ),
                              ),
                            );
                          }

                          /// Listing comments
                          return Flexible(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: ListView.builder(
                                controller: _commentListScrollController,
                                shrinkWrap: true,
                                itemCount: comments.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ReelComment(
                                    comment: comments[index],
                                    sameUser: comments[index].user!.uid == authState.uid,
                                  );
                                },
                              ),
                            ),
                          );
                        }

                        /// List Tile Shimmer Loading
                        return Flexible(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: const ListTileShimmerLoading(),
                          ),
                        );
                      },
                      listener: (context, state) {},
                    ),
                  ],
                ),
              ),

              /// Comment Posting Button
              floatingActionButton: BlocBuilder<ReelCommentBloc, ReelCommentState>(
                builder: (context, state) {
                  if (state is FetchedReelCommentState) {
                    return FloatingActionButton(
                      onPressed: () {
                        BlocProvider.of<ReelCommentBloc>(context).add(
                          AddReelCommentEvent(
                            comments: state.comments,
                            reelId: widget.reelId,
                            text: _commentController.value.text,
                          ),
                        );

                        Future.delayed(const Duration(seconds: 1), () {
                          /// making text value blank
                          _commentController.text = '';

                          /// Scrolling to the end after 1 sec when comment is posted
                          _commentListScrollController.animateTo(
                            _commentListScrollController.position.maxScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                        });
                      },
                      child: const Icon(Icons.send_outlined),
                    );
                  }
                  return Container();
                },
              ),
              bottomSheet: Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _commentController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: null,
                  autofocus: widget.autofocus,
                  decoration: const InputDecoration(
                    hintText: 'Write something',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.comment_outlined),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)
                    ),
                  ),
                ),
              ),
            );
          }
          return const ErrorMessage(message: 'Please login again.');
        }
    );
  }
}
