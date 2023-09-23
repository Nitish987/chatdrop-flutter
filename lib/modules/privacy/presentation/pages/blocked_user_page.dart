import 'package:chatdrop/modules/privacy/presentation/bloc/blocked_user/blocked_user_bloc.dart';
import 'package:chatdrop/modules/privacy/presentation/bloc/blocked_user/blocked_user_event.dart';
import 'package:chatdrop/modules/privacy/presentation/bloc/blocked_user/blocked_user_state.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:chatdrop/shared/tools/avatar_image_provider.dart';
import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:chatdrop/shared/widgets/list_tile_shimmer_loading.dart';
import 'package:chatdrop/shared/widgets/messages.dart';
import 'package:chatdrop/shared/illustrations/nothing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlockedUserPage extends StatefulWidget {
  const BlockedUserPage({Key? key}) : super(key: key);

  @override
  State<BlockedUserPage> createState() => _BlockedUserPageState();
}

class _BlockedUserPageState extends State<BlockedUserPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BlockedUserBloc>(context).add(ListBlockedUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Blocked Users'),
      ),
      body: BlocBuilder<BlockedUserBloc, BlockedUserState>(
        builder: (context, state) {
          if (state is BlockUserListState) {
            List<UserModel> users = state.blockedUsers;

            if (users.isEmpty) {
              return const Nothing(label: 'No blocked users found.');
            }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                UserModel user = users[index];
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
          else if (state is FailedBlockUserList) {
            return ErrorMessage(message: state.error);
          } else {
            return const ListTileShimmerLoading();
          }
        },
      ),
    );
  }
}
