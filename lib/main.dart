import 'package:camera/camera.dart';
import 'package:chatdrop/settings/theme/dark.dart';
import 'package:chatdrop/settings/theme/light.dart';
import 'package:chatdrop/shared/bloc/reel_feed/reel_feed_bloc.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'shared/bloc/notifier/notifier_bloc.dart';
import 'shared/bloc/story_feed/story_feed_bloc.dart';
import 'shared/bloc/timeline_feed/timeline_feed_bloc.dart';
import 'settings/firebase/firebase_options.dart';
import 'settings/hardware/hardware.dart';
import 'settings/routes/routes.dart';
import 'shared/bloc/profile/profile_bloc.dart';
import 'shared/cubit/auth/auth_cubit.dart';
import 'shared/cubit/internet/internet_cubit.dart';
import 'shared/services/fcm_service.dart';
import 'shared/services/push_notification_service.dart';

/// App Entry Point
void main() async {
  // loading dotenv
  await dotenv.load(fileName: ".env");

  // initializing flutter widgets binding
  WidgetsFlutterBinding.ensureInitialized();

  // initializing flutter push notification services
  PushNotificationService.initialize();

  // predefining available camera
  Cameras.cameras = await availableCameras();

  // initializing app according to platform - (Android, IOS)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // app check validation in production environment
  await FirebaseAppCheck.instance.activate(
    androidProvider: kReleaseMode ? AndroidProvider.playIntegrity : AndroidProvider.debug,
  );

  // FCM setup
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  
  /// fixing display orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // run App
  runApp(const App());
}

/// FCM background messages handler
@pragma('vm:entry-point')
Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
  await dotenv.load(fileName: ".env");
  await FCMessagingService.processInBackground(message);
}

/// Entry Widget
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => InternetConnectivityCubit()),
        BlocProvider(create: (context) => AuthenticationCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => StoryFeedBloc()),
        BlocProvider(create: (context) => TimelineFeedBloc()),
        BlocProvider(create: (context) => ReelFeedBloc()),
        BlocProvider(create: (context) => NotifierBloc()),
        BlocProvider(create: (context) => ProfileBloc()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          // getting theme
          ThemeData themeData;
          if(state == ThemeState.light) {
            themeData = getLightTheme(context);
          } else {
            themeData = getDarkTheme(context);
          }

          // material app
          return MaterialApp(
            theme: themeData,
            initialRoute: '/',
            onGenerateRoute: Routes.routes,
            debugShowCheckedModeBanner: false,
          );
        }
      ),
    );
  }
}