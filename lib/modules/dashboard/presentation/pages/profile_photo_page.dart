import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/widgets/appbar_title.dart';
import '../../../../shared/widgets/loading.dart';
import '../../../../shared/models/full_profile_model/full_profile_model.dart';
import '../../../../shared/bloc/profile/profile_bloc.dart';
import '../../../../shared/bloc/profile/profile_event.dart';
import '../../../../shared/bloc/profile/profile_state.dart';

class ProfilePhotoPage extends StatefulWidget {
  final FullProfileModel? model;

  const ProfilePhotoPage({Key? key, this.model}) : super(key: key);

  @override
  State<ProfilePhotoPage> createState() => _ProfilePhotoPageState();
}

class _ProfilePhotoPageState extends State<ProfilePhotoPage> {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Unable to pick images.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
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
        title: const AppBarTitle(title: 'Profile Pic'),
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
            if (_imagePath == null || state is ProfilePhotoUpdateFailedState) {
              if ((widget.model?.profile?.photo as String).isEmpty) {
                return const Center(
                  child: Text('No Photo Set.'),
                );
              }
              return CachedNetworkImage(
                imageUrl: widget.model?.profile?.photo as String,
                placeholder: (context, url) {
                  return Container(color: Colors.grey.shade300);
                },
              );
            } else {
              if (state is ProfilePhotoUpdateLoadingState) {
              return const Loading();
            } else {
              return Image.file(
                File(_imagePath.toString()),
              );
            }
            }
          },
          listener: (context, state) {
            if (state is ProfilePhotoUpdateFailedState) {
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
                    'Profile Pic Updated Successfully.',
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
          if (_imagePath == null || state is ProfilePhotoUpdateLoadingState) {
            return Container();
          } else {
            return FloatingActionButton(
              onPressed: () {
                BlocProvider.of<ProfileBloc>(context).add(
                    ProfilePhotoUpdateEvent(widget.model!,
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
