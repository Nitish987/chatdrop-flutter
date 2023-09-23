import 'package:chatdrop/modules/friend/presentation/delegate/search_friend_delegate.dart';
import 'package:chatdrop/shared/cubit/my_friend_list/my_friend_list_state.dart';
import 'package:chatdrop/shared/cubit/my_friend_list/my_friend_list_cubit.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:chatdrop/shared/tools/avatar_image_provider.dart';
import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:chatdrop/shared/widgets/list_tile_shimmer_loading.dart';
import 'package:chatdrop/shared/illustrations/nothing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyFriendListPage extends StatefulWidget {
  const MyFriendListPage({Key? key}) : super(key: key);

  @override
  State<MyFriendListPage> createState() => _MyFriendListPageState();
}

class _MyFriendListPageState extends State<MyFriendListPage> {
  final SearchFriendDelegate _searchFriendDelegate = SearchFriendDelegate();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'My Friends'),
        actions: [
          BlocBuilder<MyFriendListCubit, MyFriendListState>(
            builder: (context, state) {
              if (state is MyFriendListedState) {
                return IconButton(
                  onPressed: () async {
                    UserModel? user = await showSearch<UserModel?>(
                      context: context,
                      delegate: _searchFriendDelegate,
                    );
                    if (mounted) {
                      Navigator.pop(context, user);
                    }
                  },
                  icon: const Icon(Icons.search),
                );
              }
              return const SizedBox();
            }
          ),
        ],
      ),
      body: BlocBuilder<MyFriendListCubit, MyFriendListState>(
        builder: (context, state) {
          if (state is MyFriendListedState) {
            List<UserModel> friends = state.friends;
            _searchFriendDelegate.friends = friends;

            if (friends.isEmpty) {
              return const Nothing(label: 'No friends found.');
            }

            return ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                UserModel user = friends[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: Avatar.getAvatarProvider(
                      user.gender.toString(),
                      user.photo,
                    ),
                  ),
                  title: Text(user.name.toString()),
                  subtitle: Text(user.message.toString()),
                  onTap: () {
                    Navigator.pop(context, user);
                  },
                );
              },
            );
          } else {
            return const ListTileShimmerLoading();
          }
        },
      ),
    );
  }
}
