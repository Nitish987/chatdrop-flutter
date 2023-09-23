import 'package:chatdrop/shared/models/full_profile_model/full_profile_model.dart';
import 'package:chatdrop/shared/bloc/profile/profile_bloc.dart';
import 'package:chatdrop/modules/setting/presentation/controllers/setting_controller.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key, required this.profileModel}) : super(key: key);

  final FullProfileModel profileModel;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final SettingController _settingController = SettingController();

  void _showPostVisibilityDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Post Visibility'),
          content: const Text('Set post visibility default settings - public, only friends or private'),
          actions: [
            TextButton(
              child: const Text('public'),
              onPressed: () async {
                Navigator.of(context).pop();
                final success = await _settingController.updatePostVisibility('public');
                if(success) {
                  setState(() {
                    _settingController.postVisibility = 'public';
                  });
                }
              }
            ),
            TextButton(
                child: const Text('only friends'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  final success = await _settingController.updatePostVisibility('only_friends');
                  if(success) {
                    setState(() {
                      _settingController.postVisibility = 'only_friends';
                    });
                  }
                }
            ),
            TextButton(
              child: const Text('private'),
              onPressed: () async {
                Navigator.of(context).pop();
                final success = await _settingController.updatePostVisibility('private');
                if(success) {
                  setState(() {
                    _settingController.postVisibility = 'private';
                  });
                }
              }
            ),
            TextButton(
              child: const Text('close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showReelVisibilityDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reel Visibility'),
          content: const Text('Set reel visibility default settings - public, only friends or private'),
          actions: [
            TextButton(
                child: const Text('public'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  final success = await _settingController.updateReelVisibility('public');
                  if(success) {
                    setState(() {
                      _settingController.reelVisibility = 'public';
                    });
                  }
                }
            ),
            TextButton(
                child: const Text('only friends'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  final success = await _settingController.updateReelVisibility('only_friends');
                  if(success) {
                    setState(() {
                      _settingController.reelVisibility = 'only_friends';
                    });
                  }
                }
            ),
            TextButton(
                child: const Text('private'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  final success = await _settingController.updateReelVisibility('private');
                  if(success) {
                    setState(() {
                      _settingController.reelVisibility = 'private';
                    });
                  }
                }
            ),
            TextButton(
              child: const Text('close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _settingController.initialize(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Settings'),
      ),
      body: ListView(
        children: [
          /// Account
          const ListTile(
            title: Text('Account',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          ListTile(
            title: const Text('Change Name and Username'),
            subtitle: const Text('You can change your name and username, which is visible on your profile.'),
            onTap: () {
              Navigator.pushNamed(context, Routes.changeNames, arguments: {
                'profile_model': widget.profileModel,
                'context_value': BlocProvider.of<ProfileBloc>(context),
              });
            },
          ),
          ListTile(
            title: const Text('Change Password'),
            subtitle: const Text('Change your password in case you forget old password'),
            onTap: () {
              Navigator.pushNamed(context, Routes.changePassword);
            },
          ),
          ListTile(
            title: const Text('Blocked Users'),
            subtitle: const Text('View blocked users, which was block by you'),
            onTap: () {
              Navigator.pushNamed(context, Routes.blockUser);
            },
          ),

          /// Profile
          const ListTile(
            title: Text('Profile',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          SwitchListTile(
            value: _settingController.isProfilePrivate,
            title: const Text('Private Profile'),
            subtitle: Text(
                _settingController.isProfilePrivate ? 'Your profile is private now' :
                'You can make your profile private where no one can view about, (private and only friends) post , photos '
                    'and covers on visiting your profile',
            ),
            onChanged: (value) async {
              bool success = await _settingController.setProfilePrivateState(value);
              if(success) {
                setState(() {
                  _settingController.isProfilePrivate = value;
                });
              }
            },
          ),

          /// Post
          const ListTile(
            title: Text('Post',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          ListTile(
            title: const Text('Default Post Visibility'),
            subtitle: Text('current - ${_settingController.postVisibility.split('_').join(' ')}'),
            onTap: () {
              _showPostVisibilityDialog();
            },
          ),

          /// Reel
          const ListTile(
            title: Text('Reel',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          ListTile(
            title: const Text('Default Reel Visibility'),
            subtitle: Text('current - ${_settingController.reelVisibility.split('_').join(' ')}'),
            onTap: () {
              _showReelVisibilityDialog();
            },
          ),

          /// Olivia Ai
          const ListTile(
            title: Text('Olivia Ai',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          SwitchListTile(
            value: _settingController.allowChatGptInfoAccess,
            title: const Text('Information Access'),
            subtitle: Text(
              _settingController.allowChatGptInfoAccess ? 'You have given information (date of birth, bio and interest) access to Olivia Ai' :
              'Allowing this will give information (date of birth, bio and interest) access to Olivia Ai',
            ),
            onChanged: (value) async {
              bool success = await _settingController.setAllowChatGptInfoAccess(value);
              if(success) {
                setState(() {
                  _settingController.allowChatGptInfoAccess = value;
                });
              }
            },
          ),

          /// Theme
          const ListTile(
            title: Text('Theme',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return SwitchListTile(
                value: state == ThemeState.dark,
                title: const Text('App Theme'),
                subtitle: Text('current - ${state.name}'),
                onChanged: (value) {
                    BlocProvider.of<ThemeCubit>(context).changeTheme();
                },
              );
            }
          ),

          const SizedBox(height: 200),
        ],
      ),
    );
  }
}
