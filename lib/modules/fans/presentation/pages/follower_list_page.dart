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

class FollowerListPage extends StatefulWidget {
  final String uid;
  const FollowerListPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<FollowerListPage> createState() => _FollowerListPageState();
}

class _FollowerListPageState extends State<FollowerListPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FansBloc>(context).add(FetchFollowersEvent(widget.uid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Followers'),
      ),
      body: BlocBuilder<FansBloc, FansState>(
        builder: (context, state) {
          if (state is ListFollowersState) {
            List<UserModel> followers = state.users;

            if (followers.isEmpty) {
              return const Nothing();
            }

            return ListView.builder(
              itemCount: followers.length,
              itemBuilder: (context, index) {
                UserModel user = followers[index];
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
