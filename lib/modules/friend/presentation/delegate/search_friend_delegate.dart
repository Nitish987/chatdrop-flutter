import 'package:chatdrop/shared/illustrations/nothing.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:chatdrop/shared/tools/avatar_image_provider.dart';
import 'package:flutter/material.dart';

class SearchFriendDelegate extends SearchDelegate<UserModel?> {
  List<UserModel> _friends = [];

  set friends(List<UserModel> friends) {
    _friends = friends;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<UserModel> filtered = _friends.where((user) {
      return user.name!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (filtered.isEmpty) {
      return const Nothing(label: 'No friends found.');
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        UserModel user = filtered[index];
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
            close(context, user);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: _friends.length,
      itemBuilder: (context, index) {
        UserModel user = _friends[index];
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
            close(context, user);
          },
        );
      },
    );
  }
}