import 'package:chatdrop/shared/models/profile_model/profile_model.dart';
import 'package:chatdrop/shared/tools/web_visit.dart';
import 'package:flutter/material.dart';

class FriendProfileAbout extends StatelessWidget {
  final ProfileModel profile;
  const FriendProfileAbout({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (profile.bio as String != '')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bio',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(profile.bio as String),
              const SizedBox(height: 15),
            ],
          )
        else
          const SizedBox(height: 0),
        if (profile.interest as String != '')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Interest',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Row(
                children:
                profile.interest.toString().split(',').map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Chip(
                      label: Text(e),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 15),
            ],
          )
        else
          const SizedBox(height: 0),
        if (profile.location as String != '')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(profile.location as String),
              const SizedBox(height: 15),
            ],
          )
        else
          const SizedBox(height: 0),
        if (profile.website as String != '')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Website',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              InkWell(
                onTap: () {
                  webVisit(profile.website.toString());
                },
                child: Text(
                  profile.website as String,
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          )
        else
          const SizedBox(height: 0),
        if (profile.bio as String == '' && profile.interest as String == '' && profile.location as String == '' && profile.website as String == '')
          const Center(
            heightFactor: 5,
            child: Text('Nothing to show.'),
          ),
      ],
    );
  }
}
