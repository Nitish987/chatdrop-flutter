import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatdrop/shared/models/profile_cover_photo_model/profile_cover_photo_model.dart';
import 'package:chatdrop/shared/models/profile_photo_model/profile_photo_model.dart';
import 'package:flutter/material.dart';

class FriendProfilePhotoDialog<T> extends StatelessWidget {
  final T photoModel;
  const FriendProfilePhotoDialog({Key? key, required this.photoModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      photoModel is ProfilePhotoModel
                          ? 'Photo'
                          : 'Cover Photo',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            ),
            InteractiveViewer(
              clipBehavior: Clip.none,
              child: CachedNetworkImage(
                imageUrl: photoModel is ProfilePhotoModel
                    ? (photoModel as ProfilePhotoModel ).photo!
                    : (photoModel as ProfileCoverPhotoModel).cover!,
                placeholder: (context, url) {
                  return Container(color: Colors.grey.shade300);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}