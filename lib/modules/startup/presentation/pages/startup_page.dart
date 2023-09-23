import 'package:chatdrop/settings/constants/assets_constant.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/cubit/auth/auth_cubit.dart';
import 'package:chatdrop/shared/cubit/auth/auth_state.dart';
import 'package:chatdrop/shared/cubit/internet/internet_cubit.dart';
import 'package:chatdrop/shared/cubit/internet/internet_state.dart';
import 'package:chatdrop/shared/services/user_service.dart';
import 'package:chatdrop/shared/tools/snackbar_message.dart';
import 'package:chatdrop/settings/utilities/directory_settings.dart';
import 'package:chatdrop/shared/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({Key? key}) : super(key: key);

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage(LogoAssets.chatdrop),
              height: 50,
              width: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(20),

              /// Internet Connectivity Cubit
              child: BlocBuilder<InternetConnectivityCubit, InternetState>(
                builder: (context, state) {
                  if (state == InternetState.lost) {
                    return const Text(
                      "No Internet Connectivity.",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else if (state == InternetState.gained) {
                    /// Authentication Cubit
                    return BlocConsumer<AuthenticationCubit, AuthState>(
                      listener: (context, state) async {
                        // requesting storage permission
                        if (await Permission.storage.request().isGranted || (await Permission.photos.request().isGranted && await Permission.videos.request().isGranted)) {
                          // Creating directories
                          DirectorySettings.configDirs();
                          if (state is Authenticated) {
                              // loading identity key, registration id and authentication data
                              UserService.loadAuthenticationData(
                                onFinish: () {
                                  debugPrint('Authenticated');
                                  if (mounted) {
                                    Navigator.pushReplacementNamed(context, Routes.dashboard);
                                  }
                                },
                                onError: (error) {
                                  debugPrint('Unauthenticated');
                                  if (mounted) {
                                    Navigator.pushReplacementNamed(context, Routes.login);
                                  }
                                }
                              );
                          } else if (state is UnAuthenticated && mounted) {
                            debugPrint('Unauthenticated');
                            Navigator.pushReplacementNamed(context, Routes.login);
                          }
                        } else {
                          if (mounted) {
                            ErrorSnackBar.show(
                              context,
                              'Requires Storage Permission.',
                            );
                          }
                        }
                      },
                      builder: (context, state) {
                        return const Loading();
                      },
                    );
                  } else {
                    return const Loading();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
