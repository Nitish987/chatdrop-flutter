import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatdrop/shared/models/profile_cover_photo_model/profile_cover_photo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/friend/friend_bloc.dart';
import '../bloc/friend/friend_state.dart';
import 'friend_profile_photo_dialog.dart';

class FriendProfileCovers extends StatelessWidget {
  final List<ProfileCoverPhotoModel> profileCoverPhotos;

  const FriendProfileCovers({Key? key, required this.profileCoverPhotos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (profileCoverPhotos.isEmpty) {
      return const Center(
        heightFactor: 5,
        child: Text('No cover photos yet.'),
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
              itemCount: profileCoverPhotos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemBuilder: (context, index) {
                ProfileCoverPhotoModel profileCoverPhoto =
                    profileCoverPhotos[index];
                return InkWell(
                  child: CachedNetworkImage(
                    key: Key(profileCoverPhoto.id.toString()),
                    imageUrl: profileCoverPhoto.cover!,
                    fit: BoxFit.cover,
                    placeholder: (context, value) {
                      return Container(color: Colors.grey);
                    },
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) =>
                          FriendProfilePhotoDialog<ProfileCoverPhotoModel>(
                        photoModel: profileCoverPhoto,
                      ),
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
