import 'package:flutter/material.dart';

class ListTileShimmerLoading extends StatelessWidget {
  const ListTileShimmerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return ListView(
      shrinkWrap: true,
      children: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15].map(
        (e) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            leading: const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
            ),
            title: Container(
              width: media.size.width,
              height: 15,
              decoration: const BoxDecoration(color: Colors.grey),
            ),
            subtitle: Container(
              width: media.size.width,
              height: 10,
              decoration: const BoxDecoration(color: Colors.grey),
            ),
            trailing: const Icon(
              Icons.fiber_manual_record_rounded,
              color: Colors.grey,
            ),
          );
        },
      ).toList(),
    );
  }
}
