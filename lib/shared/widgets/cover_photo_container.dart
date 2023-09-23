import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CoverPhotoContainer extends StatelessWidget {
  final String? coverPhotoUrl;
  const CoverPhotoContainer({Key? key, this.coverPhotoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (coverPhotoUrl == null || coverPhotoUrl == '') {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        color: Colors.grey,
      );
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 150,
      child: CachedNetworkImage(
        imageUrl: coverPhotoUrl.toString(),
        fit: BoxFit.cover,
      ),
    );
  }
}
