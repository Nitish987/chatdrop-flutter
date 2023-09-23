import 'package:chatdrop/modules/post/presentation/bloc/post/post_bloc.dart';
import 'package:chatdrop/modules/post/presentation/bloc/post/post_event.dart';
import 'package:chatdrop/modules/post/presentation/bloc/post/post_state.dart';
import 'package:chatdrop/shared/cubit/auth/auth_cubit.dart';
import 'package:chatdrop/shared/cubit/auth/auth_state.dart';
import 'package:chatdrop/shared/models/post_model/post_model.dart';
import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:chatdrop/shared/widgets/messages.dart';
import 'package:chatdrop/shared/illustrations/nothing.dart';
import 'package:chatdrop/shared/widgets/post.dart';
import 'package:chatdrop/shared/widgets/post_feed_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PostBloc>(context).add(ListPostEvent(widget.uid));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthState>(
      builder: (context, authState) {
        if (authState is Authenticated) {
          return Scaffold(
            appBar: AppBar(
              title: const AppBarTitle(title: 'Posts'),
            ),
            body: BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                if (state is ListPostState) {
                  List<PostModel> posts = state.posts;

                  if (posts.isEmpty) {
                    return const Nothing();
                  }

                  /// Listing user posts
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return Post(
                        key: Key(posts[index].id.toString()),
                        post: posts[index],
                        sameUser: (posts[index].user!.uid == authState.uid),
                      );
                    },
                  );
                }
                return const PostFeedShimmerLoading();
              },
            ),
          );
        }
        return const ErrorMessage(message: 'Please login again.');
      },
    );
  }
}
