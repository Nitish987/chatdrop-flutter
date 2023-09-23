import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/theme/theme_cubit.dart';
import '../cubit/theme/theme_state.dart';
import '../models/post_model/post_model.dart';

class PostPhotos extends StatefulWidget {
  const PostPhotos({super.key, required this.photos});
  final List<PostPhotoModel> photos;

  @override
  State<PostPhotos> createState() => _PostPhotosState();
}

class _PostPhotosState extends State<PostPhotos> {
  late ThemeState theme;
  int photosIndex = 0;

  @override
  void initState() {
    theme = BlocProvider.of<ThemeCubit>(context).state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.photos.length == 1) {
      return AspectRatio(
        aspectRatio: widget.photos[0].aspectRatio!,
        child: InteractiveViewer(
          child: CachedNetworkImage(
            imageUrl: widget.photos[0].url!,
            fit: BoxFit.cover,
            placeholder: (context, value) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 400,
                decoration: const BoxDecoration(color: Colors.grey),
              );
            },
          ),
        ),
      );
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 400,
      child: Stack(
        children: [
          PageView(
            children: widget.photos.map((photo) {
              return InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: photo.url!,
                  fit: BoxFit.cover,
                  height: 400,
                  placeholder: (context, value) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      decoration: const BoxDecoration(color: Colors.grey),
                    );
                  },
                ),
              );
            }).toList(),
            onPageChanged: (index) {
              setState(() {
                photosIndex = index;
              });
            },
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: theme == ThemeState.light ? Colors.white : Colors.black,
              ),
              child: Text('${photosIndex + 1}/${widget.photos.length}'),
            ),
          ),
        ],
      ),
    );
  }
}
