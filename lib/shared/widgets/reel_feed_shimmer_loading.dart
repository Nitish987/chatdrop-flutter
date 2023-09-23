import 'package:flutter/material.dart';

class ReelFeedShimmerLoading extends StatelessWidget {
  const ReelFeedShimmerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: [1, 2, 3, 4, 5, 6, 7].map((e) {
          return Container(
            width: 140,
            height: 200,
            margin: const EdgeInsets.only(right: 5),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.grey,
            ),
          );
        },
      ).toList(),
    );
  }
}
