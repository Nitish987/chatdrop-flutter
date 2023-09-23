import 'package:chatdrop/modules/dashboard/presentation/widgets/home_feeds_shimmer_loading.dart';
import 'package:chatdrop/modules/dashboard/presentation/widgets/reels_container.dart';
import 'package:chatdrop/shared/cubit/auth/auth_cubit.dart';
import 'package:chatdrop/shared/cubit/auth/auth_state.dart';
import 'package:chatdrop/shared/models/post_model/post_model.dart';
import 'package:chatdrop/shared/widgets/loading.dart';
import 'package:chatdrop/shared/widgets/messages.dart';
import 'package:chatdrop/shared/illustrations/nothing.dart';
import 'package:chatdrop/shared/widgets/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/bloc/timeline_feed/timeline_feed_bloc.dart';
import '../../../../shared/bloc/timeline_feed/timeline_feed_event.dart';
import '../../../../shared/bloc/timeline_feed/timeline_feed_state.dart';
import '../widgets/stories_container.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final ScrollController _scrollController = ScrollController();
  int _page = 2;
  bool _hasNext = false;

  void fetchFeeds() {
    BlocProvider.of<TimelineFeedBloc>(context).add(FetchTimelineFeedEvent(page: _page));
    _page += 1;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset == _scrollController.position.maxScrollExtent && _hasNext) {
        fetchFeeds();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthState>(
      builder: (context, authState) {
        if (authState is Authenticated) {
          return BlocBuilder<TimelineFeedBloc, TimelineFeedState>(
            builder: (context, state) {
              if (state is FetchedTimelineFeedState) {
                List<PostModel> posts = state.posts;
                _hasNext = state.hasNext;

                if (posts.isEmpty) {
                  return const Nothing(
                    margin: EdgeInsets.only(top: 160),
                    label: 'No post available.',
                  );
                }

                /// Listing post feeds on timeline
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  controller: _scrollController,
                  itemCount: posts.length + 3,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const StoriesContainer();
                    } else if (index == 1) {
                      return const ReelsContainer();
                    } else {
                      if (index - 2 < posts.length) {
                        PostModel post = posts[index - 2];
                        return Post(
                          key: Key(post.id.toString()),
                          post: post,
                          sameUser: post.user!.uid == authState.uid,
                        );
                      } else {
                        if (state.hasNext) {
                          return const Padding(
                            padding: EdgeInsets.all(10),
                            child: Loading(),
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(10),
                            child: CenterMessage(message: "You're all caught up for now"),
                          );
                        }
                      }
                    }
                  },
                );
              }
              return const HomeFeedsShimmerLoading();
            },
          );
        }
        return const ErrorMessage(message: 'Please login again.');
      }
    );
  }
}
