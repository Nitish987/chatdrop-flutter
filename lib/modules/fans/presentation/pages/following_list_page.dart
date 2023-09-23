import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:chatdrop/shared/tools/avatar_image_provider.dart';
import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:chatdrop/shared/widgets/list_tile_shimmer_loading.dart';
import 'package:chatdrop/shared/widgets/messages.dart';
import 'package:chatdrop/shared/illustrations/nothing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/fans/fans_bloc.dart';
import '../bloc/fans/fans_event.dart';
import '../bloc/fans/fans_state.dart';

class FollowingListPage extends StatefulWidget {
  final String uid;
  const FollowingListPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<FollowingListPage> createState() => _FollowingListPageState();
}

class _FollowingListPageState extends State<FollowingListPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FansBloc>(context).add(FetchFollowingsEvent(widget.uid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Followings'),
      ),
      body: BlocBuilder<FansBloc, FansState>(
        builder: (context, state) {
          if (state is ListFollowingsState) {
            List<UserModel> followings = state.users;

            if (followings.isEmpty) {
              return const Nothing();
            }

            return ListView.builder(
              itemCount: followings.length,
              itemBuilder: (context, index) {
                UserModel user = followings[index];
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
                    Navigator.pushNamed(context, Routes.friendProfile, arguments: {
                      'uid': user.uid
                    });
                  },
                );
              },
            );
          }
          else if (state is FansFailedState) {
            return ErrorMessage(message: state.error);
          } else {
            return const ListTileShimmerLoading();
          }
        },
      ),
    );
  }
}
