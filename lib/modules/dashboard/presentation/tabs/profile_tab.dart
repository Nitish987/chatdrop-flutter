import 'package:chatdrop/modules/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:chatdrop/settings/constants/chatdrop_constant.dart';
import 'package:chatdrop/shared/cubit/auth/auth_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:chatdrop/shared/tools/avatar_image_provider.dart';
import 'package:chatdrop/shared/tools/web_visit.dart';
import 'package:chatdrop/shared/widgets/bottom_sheet_container.dart';
import 'package:chatdrop/shared/widgets/cover_photo_container.dart';
import 'package:chatdrop/shared/widgets/option.dart';
import 'package:chatdrop/shared/widgets/profile_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../settings/routes/routes.dart';
import '../../../../shared/widgets/messages.dart';
import '../../../../shared/widgets/profile_fan_following.dart';
import '../../../../shared/widgets/profile_name.dart';
import '../../../../shared/models/full_profile_model/full_profile_model.dart';
import '../../../../shared/bloc/profile/profile_bloc.dart';
import '../../../../shared/bloc/profile/profile_state.dart';
import '../widgets/profile_sections.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final DashboardController _dashboardController = DashboardController();
  late ThemeState theme;

  void _showMoreOptionModalBottomSheet(BuildContext profileBlocContext, FullProfileModel profileModel) async {
    bool isLogoutChosen = false;

    await showModalBottomSheet(
      constraints: BoxConstraints(maxHeight: 300, minWidth: MediaQuery.of(context).size.width),
      context: context,
      builder: (context) {
        return BottomSheetContainer(
          height: 300,
          children: [
            Option(
              label: 'Settings',
              icon: Icons.settings_outlined,
              color: Colors.blue,
              onPressed: () {
                Navigator.popAndPushNamed(context, Routes.setting, arguments: {
                  'profile_model': profileModel,
                });
              },
            ),
            Option(
              label: 'Privacy Policy',
              icon: Icons.privacy_tip_outlined,
              color: Colors.blue,
              onPressed: () {
                webVisit(ChatdropConstant.privacyUrl);
              },
            ),
            Option(
              label: 'Terms',
              icon: Icons.privacy_tip_outlined,
              color: Colors.blue,
              onPressed: () {
                webVisit(ChatdropConstant.termsUrl );
              },
            ),
            Option(
              label: 'Logout',
              icon: Icons.logout_outlined,
              color: Colors.red,
              onPressed: () {
                isLogoutChosen = true;
                _dashboardController.logoutAuthenticatedUser();
                BlocProvider.of<AuthenticationCubit>(context).setAuthenticationState();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );

    if (mounted && isLogoutChosen) {
      Navigator.popAndPushNamed(context, Routes.login);
    }
  }

  @override
  void initState() {
    theme = BlocProvider.of<ThemeCubit>(context).state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadingState ||
            state is ProfileUpdateLoadingState ||
            state is ProfilePhotoSwitchLoadingState ||
            state is ProfilePhotoDeleteLoadingState ||
            state is ProfileCoverPhotoSwitchLoadingState ||
            state is ProfileCoverPhotoDeleteLoadingState ||
            state is ProfileInitialState) {
          return const ProfileShimmerLoading();
        } else if (state is ProfileFailedState) {
          return ErrorMessage(message: state.error);
        } else if (state is ProfileSuccessState) {
          FullProfileModel profileModel = state.profileModel;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  children: [
                    InkWell(
                      child: CoverPhotoContainer(
                        coverPhotoUrl: profileModel.profile?.coverPhoto,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, Routes.profileCoverPhoto, arguments: {
                            'profile_model': profileModel,
                          },
                        );
                      },
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.only(top: 80),
                      child: InkWell(
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: theme == ThemeState.light ? Colors.white: Colors.black,
                          child: CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.grey,
                            backgroundImage: Avatar.getAvatarProvider(
                              profileModel.profile?.gender as String,
                              profileModel.profile?.photo,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, Routes.profilePhoto, arguments: {
                              'profile_model': profileModel,
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                ProfileName(
                  name: profileModel.profile?.name as String,
                  message: profileModel.profile?.message as String,
                ),
                const SizedBox(height: 10),
                ProfileFanFollowing(
                  followers: profileModel.profile?.followerCount as int,
                  followings: profileModel.profile?.followingCount as int,
                  posts: profileModel.profile?.postCount as int,
                  reels: profileModel.profile?.reelCount as int,
                  onFollowersPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.followers,
                      arguments: {'uid': profileModel.profile!.uid},
                    );
                  },
                  onFollowingsPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.followings,
                      arguments: {'uid': profileModel.profile!.uid},
                    );
                  },
                  onPostsPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.postList,
                      arguments: {'uid': profileModel.profile!.uid},
                    );
                  },
                  onReelsPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.reelList,
                      arguments: {'uid': profileModel.profile!.uid},
                    );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add_circle),
                      label: const Text('Create Story'),
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.storyConfig);
                      },
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        if (mounted) {
                          Navigator.pushNamed(context, Routes.profileEdit, arguments: {
                            'profile_model': profileModel,
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        _showMoreOptionModalBottomSheet(context, profileModel);
                      },
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
                BlocProvider.value(
                  value: BlocProvider.of<ProfileBloc>(context),
                  child: ProfileSections(model: profileModel),
                ),
              ],
            ),
          );
        } else {
          return const ErrorMessage(message: 'Something went wrong.');
        }
      },
    );
  }
}
