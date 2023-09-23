import 'package:flutter/material.dart';

class StoryFeedShimmerLoading extends StatelessWidget {
  const StoryFeedShimmerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: [1, 2, 3, 4, 5, 6, 7].map((e) {
          return const Padding(
            padding: EdgeInsets.only(right: 5),
            child: CircleAvatar(
              radius: 33,
              backgroundColor: Colors.grey,
            ),
          );
        },
      ).toList(),
    );
  }
}
