import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatdrop/shared/tools/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/widgets/appbar_title.dart';
import '../../../../shared/widgets/loading.dart';
import '../../../../shared/models/full_profile_model/full_profile_model.dart';
import '../../../../shared/bloc/profile/profile_bloc.dart';
import '../../../../shared/bloc/profile/profile_event.dart';
import '../../../../shared/bloc/profile/profile_state.dart';

class ProfileCoverPhotoPage extends StatefulWidget {
  final FullProfileModel? model;

  const ProfileCoverPhotoPage({Key? key, this.model}) : super(key: key);

  @override
  State<ProfileCoverPhotoPage> createState() => _ProfileCoverPhotoPageState();
}

class _ProfileCoverPhotoPageState extends State<ProfileCoverPhotoPage> {
  final ImagePicker _imagePicker = ImagePicker();
  late String? _imagePath;

  void _pickImage() async {
    try {
      final XFile? xFile =
      await _imagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _imagePath = xFile?.path;
      });
    } catch (e) {
      ErrorSnackBar.show(context, 'Unable to pick image.');
    }
  }

  @override
  void initState() {
    setState(() {
      _imagePath = null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Profile Cover'),
        actions: [
          IconButton(
            onPressed: () {
              _pickImage();
            },
            icon: const Icon(Icons.edit),
            color: Colors.blue,
          )
        ],
      ),
      body: Center(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (_imagePath == null || state is ProfileCoverPhotoUpdateFailedState) {
              if ((widget.model?.profile?.coverPhoto as String).isEmpty) {
                return const Center(
                  child: Text('No Cover Photo Set.'),
                );
              }
              return CachedNetworkImage(
                imageUrl: widget.model?.profile?.coverPhoto as String,
                placeholder: (context, url) {
                  return Container(color: Colors.grey.shade300);
                },
              );
            } else if (state is ProfileCoverPhotoUpdateLoadingState) {
              return const Loading();
            } else {
              return Image.file(
                File(_imagePath.toString()),
              );
            }
          },
          listener: (context, state) {
            if (state is ProfileCoverPhotoUpdateFailedState) {
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
                    'Profile Cover Updated Successfully.',
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
      ),
      floatingActionButton: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (_imagePath == null || state is ProfileCoverPhotoUpdateLoadingState) {
            return Container();
          } else {
            return FloatingActionButton(
              onPressed: () {
                BlocProvider.of<ProfileBloc>(context).add(
                    ProfileCoverPhotoUpdateEvent(widget.model!,
                        imagePath: _imagePath!));
              },
              child: const Icon(Icons.check),
            );
          }
        },
      ),
    );
  }
}
