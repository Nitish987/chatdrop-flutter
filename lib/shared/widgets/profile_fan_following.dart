import 'package:flutter/material.dart';

class ProfileFanFollowing extends StatelessWidget {
  final int followers, followings, posts, reels;
  final Function onFollowersPressed, onFollowingsPressed, onPostsPressed, onReelsPressed;

  const ProfileFanFollowing(
      {Key? key, this.followers = 0, this.followings = 0, this.posts = 0, this.reels = 0, required this.onFollowersPressed, required this.onFollowingsPressed, required this.onPostsPressed, required this.onReelsPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          followers.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        const SizedBox(width: 5),
        InkWell(
          child: const Text('followers'),
          onTap: () => onFollowersPressed(),
        ),
        const SizedBox(width: 15),
        Text(
          followings.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        const SizedBox(width: 5),
        InkWell(
          child: const Text('followings'),
          onTap: () => onFollowingsPressed(),
        ),
        const SizedBox(width: 15),
        Text(
          posts.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        const SizedBox(width: 5),
        InkWell(
          child: const Text('posts'),
          onTap: () => onPostsPressed(),
        ),
        const SizedBox(width: 15),
        Text(
          reels.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        const SizedBox(width: 5),
        InkWell(
          child: const Text('reels'),
          onTap: () => onReelsPressed(),
        ),
      ],
    );
  }
}
