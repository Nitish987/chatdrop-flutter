import 'dart:async';
import 'dart:convert';

import 'package:chatdrop/infra/utilities/file_type.dart';
import 'package:chatdrop/modules/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:chatdrop/shared/bloc/notifier/notifier_event.dart';
import 'package:chatdrop/shared/bloc/profile/profile_event.dart';
import 'package:chatdrop/shared/bloc/reel_feed/reel_feed_bloc.dart';
import 'package:chatdrop/shared/bloc/reel_feed/reel_feed_event.dart';
import 'package:chatdrop/shared/models/notification_model/notification_model.dart';
import 'package:chatdrop/shared/services/fcm_service.dart';
import 'package:chatdrop/shared/tools/snackbar_message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import '../../../../settings/routes/routes.dart';
import '../../../../shared/cubit/auth/auth_cubit.dart';
import '../../../../shared/cubit/auth/auth_state.dart';
import '../../../../shared/widgets/appbar_title.dart';
import '../../../../shared/bloc/profile/profile_bloc.dart';
import '../../../../shared/bloc/notifier/notifier_bloc.dart';
import '../bloc/recent_chats/recent_chats_bloc.dart';
import '../../../../shared/bloc/story_feed/story_feed_bloc.dart';
import '../../../../shared/bloc/story_feed/story_feed_event.dart';
import '../../../../shared/bloc/timeline_feed/timeline_feed_bloc.dart';
import '../../../../shared/bloc/timeline_feed/timeline_feed_event.dart';
import '../providers/dashboard_tab_switcher_provider.dart';
import '../widgets/add_bottom_sheet.dart';
import '../tabs/favorite_tab.dart';
import '../tabs/home_tab.dart';
import '../tabs/profile_tab.dart';
import '../tabs/chat_tab.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardController _dashboardController = DashboardController();
  final List<BottomNavigationBarItem> _bottomNavOptions = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
      tooltip: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat_outlined),
      activeIcon: Icon(Icons.chat),
      label: 'Chats',
      tooltip: 'Chats',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_box_outlined),
      activeIcon: Icon(Icons.add_box),
      label: 'Add',
      tooltip: 'Add',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite_border_outlined),
      activeIcon: Icon(Icons.favorite),
      label: 'Favorite',
      tooltip: 'Favorite',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_outlined),
      activeIcon: Icon(Icons.account_circle),
      label: 'Profile',
      tooltip: 'Profile',
    ),
  ];
  late StreamSubscription _intentDataStreamSubscription;

  void _jumpToCapturePage(SharedFile sharedFile) {
    Future.delayed(const Duration(seconds: 2)).whenComplete(() {
      if (sharedFile.type == SharedMediaType.IMAGE) {
        Navigator.pushNamed(context, Routes.cameraCaptured, arguments: {
          'type': FileType.image,
          'path': sharedFile.value!,
        });
      } else if (sharedFile.type == SharedMediaType.VIDEO) {
        Navigator.pushNamed(context, Routes.cameraCaptured, arguments: {
          'type': FileType.video,
          'path': sharedFile.value!,
        });
      }
    });
  }

  void _showAddBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const AddBottomSheet(),
    );
  }

  void _loginCheckListener() async {
    if(!(await _dashboardController.isLoggedIn())) {
      if(mounted) {
        Navigator.popAndPushNamed(context, Routes.login);
      }
    }
  }

  void fetchStories() {
    BlocProvider.of<StoryFeedBloc>(context).add(FetchStoryFeedEvent());
  }

  void fetchFeeds() {
    BlocProvider.of<TimelineFeedBloc>(context).add(FetchTimelineFeedEvent(page: 1));
  }

  void fetchReels() {
    BlocProvider.of<ReelFeedBloc>(context).add(FetchReelFeedEvent(page: 1));
  }

  void fetchNotifications() {
    BlocProvider.of<NotifierBloc>(context).add(ListNotificationEvent(page: 1));
  }

  void appendNotification(Map<String, dynamic> data) {
    NotificationModel notification = NotificationModel.fromJson(jsonDecode(data['content']) as Map<String, dynamic>);
    if (notification.type != 'SECRET_CHAT_MESSAGE' && notification.type != 'NORMAL_CHAT_MESSAGE') {
      BlocProvider.of<NotifierBloc>(context).add(AppendNotificationEvent(notification));
    }
  }

  void fetchProfile() {
    BlocProvider.of<ProfileBloc>(context).add(ProfileFetchEvent());
  }

  @override
  void initState() {
    super.initState();
    /// checking whether the user is logged in or not
    _loginCheckListener();

    /// loading keys stores
    _dashboardController.loadKeysStores();

    /// loading feeds
    fetchStories();
    fetchFeeds();
    fetchReels();
    fetchNotifications();
    fetchProfile();

    /// intent sharing stream
    // intent sharing stream listener when app is in background
    _intentDataStreamSubscription = FlutterSharingIntent.instance.getMediaStream().listen((sharedFiles) {
      if (sharedFiles.isNotEmpty) {
        _jumpToCapturePage(sharedFiles[0]);
      }
    });
    // intent sharing stream listener when app is in foreground
    FlutterSharingIntent.instance.getInitialSharing().then((sharedFiles) {
      if (sharedFiles.isNotEmpty) {
        _jumpToCapturePage(sharedFiles[0]);
      }
    });

    /// sends the token to server if FCM token gets refreshed
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _dashboardController.updateFcmToken(fcmToken);
      });
    });

    /// listening for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      appendNotification(message.data);
      await FCMessagingService.processInForeground(message, Routes.currentRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(
        canDismissDialog: false,
        durationUntilAlertAgain: const Duration(days: 1),
        dialogStyle: UpgradeDialogStyle.material,
        showIgnore: false,
        showLater: false,
      ),
      child: BlocBuilder<AuthenticationCubit, AuthState>(
        builder: (context, state) {
          return ChangeNotifierProvider<DashboardTabSwitcherProvider>(
            create: (context) => DashboardTabSwitcherProvider(),
            child: Scaffold(
              appBar: AppBar(
                title: const AppBarTitle(),
                actions: [
                  IconButton(
                    onPressed: () async {
                      if (await Permission.camera.request().isGranted && await Permission.microphone.request().isGranted) {
                        if (mounted) {
                          Navigator.pushNamed(context, Routes.camera);
                        }
                      } else {
                        if (mounted) {
                          ErrorSnackBar.show(context, 'Requires Camera Permission');
                        }
                      }
                    },
                    icon: const Icon(Icons.camera_alt_outlined),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.search);
                    },
                    icon: const Icon(Icons.search_outlined),
                  ),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  fetchStories();
                  fetchFeeds();
                  fetchReels();
                  fetchNotifications();
                  fetchProfile();
                },
                child: Consumer<DashboardTabSwitcherProvider>(
                  builder: (context, provider, child) {
                    if (state is Authenticated) {
                      switch (provider.tabIndex) {
                        case 0:
                          return const HomeTab();
                        case 1:
                          return BlocProvider(
                            create: (context) => RecentChatsBloc(),
                            child: const ChatTab(),
                        );
                        case 3:
                          return const FavoriteTab();
                        case 4:
                          return const ProfileTab();
                      }
                    }
                    return const Center(
                      child: Text('Nothing to Show.'),
                    );
                  },
                ),
              ),
              bottomNavigationBar: Consumer<DashboardTabSwitcherProvider>(
                builder: (context, provider, child) {
                  return BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    items: _bottomNavOptions,
                    currentIndex: provider.tabIndex,
                    selectedItemColor: Colors.blue,
                    unselectedItemColor: Colors.grey,
                    onTap: (index) {
                      if (index == 2) {
                        _showAddBottomSheet(context);
                      } else {
                        provider.setTabIndex(index);
                      }
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }
}
