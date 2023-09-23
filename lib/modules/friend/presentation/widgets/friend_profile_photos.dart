import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatdrop/shared/models/profile_photo_model/profile_photo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/friend/friend_bloc.dart';
import '../bloc/friend/friend_state.dart';
import 'friend_profile_photo_dialog.dart';

class FriendProfilePhotos extends StatelessWidget {
  final List<ProfilePhotoModel> profilePhotos;

  const FriendProfilePhotos({Key? key, required this.profilePhotos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (profilePhotos.isEmpty) {
      return const Center(
        heightFactor: 5,
        child: Text('No photos yet.'),
      );
    }
    return BlocBuilder<FriendBloc, FriendState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: profilePhotos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemBuilder: (context, index) {
                ProfilePhotoModel profilePhoto = profilePhotos[index];
                return InkWell(
                  child: CachedNetworkImage(
                    key: Key(profilePhoto.id.toString()),
                    imageUrl: profilePhoto.photo!,
                    fit: BoxFit.cover,
                    placeholder: (context, value) {
                      return Container(color: Colors.grey);
                    },
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => FriendProfilePhotoDialog<ProfilePhotoModel>(
                          photoModel: profilePhoto),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
