import 'package:chatdrop/modules/dashboard/presentation/widgets/profile_about.dart';
import 'package:chatdrop/modules/dashboard/presentation/widgets/profile_covers.dart';
import 'package:chatdrop/modules/dashboard/presentation/widgets/profile_photos.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/models/full_profile_model/full_profile_model.dart';
import '../../../../shared/bloc/profile/profile_bloc.dart';
import '../../../../shared/bloc/profile/profile_state.dart';

class ProfileSections extends StatefulWidget {
  final FullProfileModel model;

  const ProfileSections({Key? key, required this.model}) : super(key: key);

  @override
  State<ProfileSections> createState() => _ProfileSectionsState();
}

class _ProfileSectionsState extends State<ProfileSections> {
  late int _selectedBtnIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedBtnIndex = 0;
                  });
                },
                child: Text(
                  'About',
                  style: TextStyle(
                    color: _selectedBtnIndex == 0 ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.postList,
                    arguments: {'uid': widget.model.profile!.uid},
                  );
                },
                child: const Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedBtnIndex = 2;
                  });
                },
                child: Text(
                  'Photos',
                  style: TextStyle(
                    color: _selectedBtnIndex == 2 ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedBtnIndex = 3;
                  });
                },
                child: Text(
                  'Cover',
                  style: TextStyle(
                    color: _selectedBtnIndex == 3 ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        const SizedBox(height: 10),
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              switch (_selectedBtnIndex) {
                case 0:
                  return ProfileAbout(profile: widget.model.profile!);
                case 2:
                  return BlocProvider.value(
                    value: BlocProvider.of<ProfileBloc>(context),
                    child: ProfilePhotos(
                      profilePhotos: widget.model.profilePhotos ?? [],
                    ),
                  );
                case 3:
                  return BlocProvider.value(
                    value: BlocProvider.of<ProfileBloc>(context),
                    child: ProfileCovers(
                      profileCoverPhotos:
                      widget.model.profileCoverPhotos ?? [],
                    ),
                  );
              }
              return const Center(
                child: Text('Nothing to Show.'),
              );
            },
          ),
        ),
      ],
    );
  }
}
