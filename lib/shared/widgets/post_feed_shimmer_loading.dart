import 'package:flutter/material.dart';

class PostFeedShimmerLoading extends StatelessWidget {
  const PostFeedShimmerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [1, 2, 3, 4].map(
        (e) {
          return Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  leading: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey,
                  ),
                  title: Container(
                    width: 200,
                    height: 15,
                    decoration: const BoxDecoration(color: Colors.grey),
                  ),
                  subtitle: Container(
                    width: 100,
                    height: 10,
                    decoration: const BoxDecoration(color: Colors.grey),
                  ),
                  trailing: const Icon(
                    Icons.more_horiz,
                    color: Colors.black,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  decoration: const BoxDecoration(color: Colors.grey),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.favorite_border,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.mode_comment_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.send_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
