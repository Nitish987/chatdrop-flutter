import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/loading.dart';
import '../../../../shared/models/full_profile_model/full_profile_model.dart';
import '../../../../shared/bloc/profile/profile_bloc.dart';
import '../../../../shared/bloc/profile/profile_event.dart';
import '../../../../shared/bloc/profile/profile_state.dart';

class EditProfilePage extends StatefulWidget {
  final FullProfileModel? model;

  const EditProfilePage({Key? key, required this.model}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late int _messageCharCount = 0;
  late int _bioCharCount = 0;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  @override
  void initState() {
    _messageController.text = widget.model?.profile?.message as String;
    _bioController.text = widget.model?.profile?.bio as String;
    _interestController.text = widget.model?.profile?.interest as String;
    _locationController.text = widget.model?.profile?.location as String;
    _websiteController.text = widget.model?.profile?.website as String;

    _messageCharCount = _messageController.text.length;
    _bioCharCount = _bioController.text.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Edit Profile'),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overflow) {
          overflow.disallowIndicator();
          return false;
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Message',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _messageController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Message',
                    prefixIcon: const Padding(
                      padding: EdgeInsetsDirectional.only(bottom: 25),
                      child: Icon(Icons.message_outlined),
                    ),
                    counterText: '${_messageCharCount.toString()} / 100',
                    counterStyle: (_messageCharCount > 100)
                        ? const TextStyle(color: Colors.red)
                        : null,
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    setState(() {
                      _messageCharCount = value.length;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Bio',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _bioController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: 'Bio',
                    prefixIcon: const Padding(
                      padding: EdgeInsetsDirectional.only(bottom: 100),
                      child: Icon(Icons.message_outlined),
                    ),
                    counterText: '${_bioCharCount.toString()} / 2000',
                    counterStyle: (_bioCharCount > 2000)
                        ? const TextStyle(color: Colors.red)
                        : null,
                  ),
                  maxLines: 7,
                  onChanged: (value) {
                    setState(() {
                      _bioCharCount = value.length;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Interest',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _interestController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Interest',
                    prefixIcon: Icon(Icons.interests_outlined),
                    helperText: 'Separate with commas. eg: Photography, Designing'
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Location',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _locationController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Location',
                    prefixIcon: Icon(Icons.location_on_outlined),
                    helperText: 'Location will not be shared to anyone.'
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Website',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _websiteController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Website',
                    prefixIcon: Icon(Icons.link_sharp),
                    helperText: 'Link should starts with https. eg: https://www.example.com'
                  ),
                ),
                const SizedBox(height: 50),
                BlocConsumer<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileUpdateLoadingState) {
                      return const Loading();
                    } else {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50)),
                        child: const Text(
                          'Save Profile',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          BlocProvider.of<ProfileBloc>(context).add(
                            ProfileUpdateEvent(
                              widget.model!,
                              message: _messageController.text,
                              bio: _bioController.text,
                              interest: _interestController.text,
                              location: _locationController.text,
                              website: _websiteController.text,
                            ),
                          );
                        },
                      );
                    }
                  },
                  listener: (context, state) {
                    if (state is ProfileUpdateFailedState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.error,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (state is ProfileSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Profile Updated Successfully.',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Future.delayed(const Duration(seconds: 1), () {
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
