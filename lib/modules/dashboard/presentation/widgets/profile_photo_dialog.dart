import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatdrop/shared/models/profile_cover_photo_model/profile_cover_photo_model.dart';
import 'package:chatdrop/shared/models/profile_photo_model/profile_photo_model.dart';
import 'package:chatdrop/shared/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/bloc/profile/profile_bloc.dart';
import '../../../../shared/bloc/profile/profile_event.dart';
import '../../../../shared/bloc/profile/profile_state.dart';

class ProfilePhotoDialog<T> extends StatelessWidget {
  final T photoModel;
  const ProfilePhotoDialog({Key? key, required this.photoModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      photoModel is ProfilePhotoModel
                          ? 'Photo'
                          : 'Cover Photo',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  BlocConsumer<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfilePhotoDeleteLoadingState ||
                          state is ProfileCoverPhotoDeleteLoadingState) {
                        return const Loading();
                      }
                      return Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {
                            if (state is ProfileSuccessState) {
                              if (photoModel is ProfilePhotoModel) {
                                BlocProvider.of<ProfileBloc>(context).add(
                                  ProfilePhotoDeleteEvent(
                                    state.profileModel,
                                    profilePhoto: photoModel as ProfilePhotoModel,
                                  ),
                                );
                              } else if (photoModel
                              is ProfileCoverPhotoModel) {
                                BlocProvider.of<ProfileBloc>(context).add(
                                  ProfileCoverPhotoDeleteEvent(
                                    state.profileModel,
                                    profileCoverPhoto: photoModel as ProfileCoverPhotoModel,
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      );
                    },
                    listener: (context, state) {
                      if (state is ProfileSuccessState) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfilePhotoSwitchLoadingState ||
                          state is ProfileCoverPhotoSwitchLoadingState) {
                        return const Loading();
                      }
                      return Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {
                            if (state is ProfileSuccessState) {
                              if (photoModel is ProfilePhotoModel) {
                                BlocProvider.of<ProfileBloc>(context).add(
                                  ProfilePhotoSwitchEvent(
                                    state.profileModel,
                                    profilePhoto: photoModel as ProfilePhotoModel,
                                  ),
                                );
                              } else if (photoModel
                              is ProfileCoverPhotoModel) {
                                BlocProvider.of<ProfileBloc>(context).add(
                                  ProfileCoverPhotoSwitchEvent(
                                    state.profileModel,
                                    profileCoverPhoto: photoModel as ProfileCoverPhotoModel,
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.swap_horiz_sharp),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            ),
            InteractiveViewer(
              clipBehavior: Clip.none,
              child: CachedNetworkImage(
                imageUrl: photoModel is ProfilePhotoModel
                    ? (photoModel as ProfilePhotoModel).photo!
                    : (photoModel as ProfileCoverPhotoModel).cover!,
                placeholder: (context, url) {
                  return Container(color: Colors.grey.shade300);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
