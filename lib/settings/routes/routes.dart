import 'package:chatdrop/modules/auth/presentation/bloc/change_names/change_names_bloc.dart';
import 'package:chatdrop/modules/auth/presentation/bloc/change_password/change_password_bloc.dart';
import 'package:chatdrop/modules/auth/presentation/bloc/forget_password/forget_password_bloc.dart';
import 'package:chatdrop/modules/auth/presentation/bloc/gsac/gsac_bloc.dart';
import 'package:chatdrop/modules/auth/presentation/bloc/login/login_bloc.dart';
import 'package:chatdrop/modules/auth/presentation/bloc/signup/signup_bloc.dart';
import 'package:chatdrop/modules/auth/presentation/pages/change_names_page.dart';
import 'package:chatdrop/modules/auth/presentation/pages/forget_password_page.dart';
import 'package:chatdrop/modules/auth/presentation/pages/gsac_page.dart';
import 'package:chatdrop/modules/auth/presentation/pages/login_page.dart';
import 'package:chatdrop/modules/auth/presentation/pages/signup_page.dart';
import 'package:chatdrop/modules/camera/presentation/bloc/audio/audio_bloc.dart';
import 'package:chatdrop/modules/camera/presentation/cubit/camera_feature/camera_feature_cubit.dart';
import 'package:chatdrop/modules/camera/presentation/pages/audio_select_page.dart';
import 'package:chatdrop/modules/camera/presentation/pages/camera_page.dart';
import 'package:chatdrop/modules/camera/presentation/pages/captured_page.dart';
import 'package:chatdrop/modules/chat/presentation/bloc/ai_chat/ai_chat_bloc.dart';
import 'package:chatdrop/modules/chat/presentation/bloc/secret_chat/secret_chat_bloc.dart';
import 'package:chatdrop/modules/chat/presentation/cubit/chat_page/chat_page_cubit.dart';
import 'package:chatdrop/modules/chat/presentation/cubit/chatting_status/chatting_status_cubit.dart';
import 'package:chatdrop/modules/chat/presentation/cubit/can_chat/can_chat_cubit.dart';
import 'package:chatdrop/modules/chat/presentation/pages/ai_chat_page.dart';
import 'package:chatdrop/modules/chat/presentation/pages/normal_chat_page.dart';
import 'package:chatdrop/modules/chat/presentation/pages/secret_chat_page.dart';
import 'package:chatdrop/modules/editor/presentation/pages/background_selector_page.dart';
import 'package:chatdrop/modules/editor/presentation/pages/video_trimmer_page.dart';
import 'package:chatdrop/modules/fans/presentation/bloc/fans/fans_bloc.dart';
import 'package:chatdrop/modules/fans/presentation/pages/follower_list_page.dart';
import 'package:chatdrop/modules/fans/presentation/pages/following_list_page.dart';
import 'package:chatdrop/modules/friend/presentation/bloc/friend/friend_bloc.dart';
import 'package:chatdrop/modules/friend/presentation/pages/friend_profile_page.dart';
import 'package:chatdrop/modules/reel/presentation/bloc/reel/reel_bloc.dart';
import 'package:chatdrop/modules/reel/presentation/bloc/reel_comment/reel_comment_bloc.dart';
import 'package:chatdrop/modules/reel/presentation/pages/reel_comment_page.dart';
import 'package:chatdrop/modules/reel/presentation/pages/reel_list_page.dart';
import 'package:chatdrop/modules/reel/presentation/pages/reel_post_page.dart';
import 'package:chatdrop/modules/reel/presentation/pages/reel_showcase_page.dart';
import 'package:chatdrop/modules/reel/presentation/pages/reel_slider_page.dart';
import 'package:chatdrop/shared/cubit/my_friend_list/my_friend_list_cubit.dart';
import 'package:chatdrop/modules/friend/presentation/pages/my_friend_list_page.dart';
import 'package:chatdrop/shared/bloc/profile/profile_bloc.dart';
import 'package:chatdrop/shared/models/full_profile_model/full_profile_model.dart';
import 'package:chatdrop/modules/dashboard/presentation/pages/edit_profile_page.dart';
import 'package:chatdrop/modules/dashboard/presentation/pages/dashboard_page.dart';
import 'package:chatdrop/modules/dashboard/presentation/pages/profile_cover_photo_page.dart';
import 'package:chatdrop/modules/dashboard/presentation/pages/profile_photo_page.dart';
import 'package:chatdrop/modules/post/presentation/bloc/post/post_bloc.dart';
import 'package:chatdrop/modules/post/presentation/pages/post_list_page.dart';
import 'package:chatdrop/modules/post/presentation/pages/post_page.dart';
import 'package:chatdrop/modules/privacy/presentation/pages/report_user_page.dart';
import 'package:chatdrop/shared/bloc/search/search_bloc.dart';
import 'package:chatdrop/modules/search/presentation/pages/search_page.dart';
import 'package:chatdrop/modules/privacy/presentation/bloc/blocked_user/blocked_user_bloc.dart';
import 'package:chatdrop/modules/privacy/presentation/pages/blocked_user_page.dart';
import 'package:chatdrop/modules/auth/presentation/pages/change_password_page.dart';
import 'package:chatdrop/modules/setting/presentation/pages/setting_page.dart';
import 'package:chatdrop/modules/startup/presentation/pages/startup_page.dart';
import 'package:chatdrop/modules/story/presentation/bloc/story/story_bloc.dart';
import 'package:chatdrop/modules/story/presentation/pages/story_config_page.dart';
import 'package:chatdrop/modules/editor/presentation/pages/image_editor_page.dart';
import 'package:chatdrop/modules/story/presentation/pages/story_post_page.dart';
import 'package:chatdrop/modules/post/presentation/bloc/post_comment/post_comment_bloc.dart';
import 'package:chatdrop/modules/post/presentation/pages/post_comment_page.dart';
import 'package:chatdrop/modules/story/presentation/pages/story_showcase_page.dart';
import 'package:chatdrop/shared/cubit/post_delete/post_delete_cubit.dart';
import 'package:chatdrop/shared/cubit/post_like/post_like_cubit.dart';
import 'package:chatdrop/shared/cubit/post_visibility/post_visibility_cubit.dart';
import 'package:chatdrop/shared/models/post_model/post_model.dart';
import 'package:chatdrop/shared/models/reel_model/reel_model.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:chatdrop/shared/pages/error_page.dart';
import 'package:chatdrop/shared/pages/file_video_viewer_page.dart';
import 'package:chatdrop/shared/pages/memory_image_viewer_page.dart';
import 'package:chatdrop/modules/post/presentation/pages/post_showcase_page.dart';
import 'package:chatdrop/shared/pages/web_image_viewer_page.dart';
import 'package:chatdrop/shared/pages/web_video_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/pages/file_image_viewer_page.dart';

/// current routes settings class
class CurrentRoute {
  String? name;
  Map<String, dynamic>? arguments;

  CurrentRoute(this.name, this.arguments);
}

/// routing generator class
class Routes {
  // current route
  static late CurrentRoute currentRoute;

  // all routes
  static const String startup = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String gsac = '/gsac';
  static const String dashboard = '/dashboard';
  static const String forgetPassword = '/forget-password';
  static const String profileEdit = '/profile/edit';
  static const String profilePhoto = '/profile/photo';
  static const String profileCoverPhoto = '/profile/cover-photo';
  static const String search = '/search';
  static const String friendProfile = '/friend/profile';
  static const String storyConfig = '/story/config';
  static const String imageEditor = '/editor/image';
  static const String videoTrimmer = '/trimmer/video';
  static const String backgroundSelector = '/background/selector';
  static const String storyPost = '/story/post';
  static const String post = '/post';
  static const String postShowcase = '/post/showcase';
  static const String postComment = '/post/comment';
  static const String storyShowcase = '/story/showcase';
  static const String postList = '/post/list';
  static const String followers = '/followers';
  static const String followings = '/followings';
  static const String myFriendList = '/my/friends';
  static const String secretChat = '/chat/secret';
  static const String normalChat = '/chat/normal';
  static const String aiChat = '/chat/ai';
  static const String setting = '/setting';
  static const String changePassword = '/changePassword';
  static const String changeNames = '/changeNames';
  static const String blockUser = '/blockUser';
  static const String reportUser = '/reportUser';
  static const String fileImageViewer = '/viewer/image/file';
  static const String webImageViewer = '/viewer/image/web';
  static const String memoryImageViewer = '/viewer/image/memory';
  static const String fileVideoViewer = '/viewer/video/file';
  static const String webVideoViewer = '/viewer/video/web';
  static const String camera = '/camera';
  static const String audio = '/audio';
  static const String cameraCaptured = '/camera/captured';
  static const String reel = '/reel';
  static const String reelSlider = '/reel/slider';
  static const String reelComment = '/reel/comment';
  static const String reelShowcase = '/reel/showcase';
  static const String reelList = '/reel/list';

  static Route<dynamic> routes(RouteSettings settings) {
    if(settings.arguments == null) {
      currentRoute = CurrentRoute(settings.name, null);
    } else {
      currentRoute = CurrentRoute(settings.name, settings.arguments as Map<String, dynamic>);
    }
    switch (settings.name) {
      /// startup page
      case Routes.startup:
        return MaterialPageRoute(builder: (context) => const StartupPage());

      /// login page
      case Routes.login:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => LoginBloc(),
            child: const LoginPage(),
          ),
        );

      /// signup page
      case Routes.signup:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => SignupBloc(),
            child: const SignupPage(),
          ),
        );

      /// google sign in account creation page
      case Routes.gsac:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => GSACBloc(),
            child: GSACPage(gsacToken: arguments['gsact'], idToken: arguments['id_token']),
          ),
        );

      /// dashboard page
      case Routes.dashboard:
        return MaterialPageRoute(builder: (context) => const DashboardPage());

      /// forget password page
      case Routes.forgetPassword:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ForgetPasswordBloc(),
            child: const ForgetPasswordPage(),
          ),
        );

      /// edit profile page
      case Routes.profileEdit:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        FullProfileModel profileModel = arguments['profile_model'];
        return MaterialPageRoute(
          builder: (context) => EditProfilePage(model: profileModel),
        );

      /// profile photo page
      case Routes.profilePhoto:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        FullProfileModel profileModel = arguments['profile_model'];
        return MaterialPageRoute(
          builder: (context) => ProfilePhotoPage(model: profileModel),
        );

      /// profile cover photo page
      case Routes.profileCoverPhoto:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        FullProfileModel profileModel = arguments['profile_model'];
        return MaterialPageRoute(
          builder: (context) => ProfileCoverPhotoPage(model: profileModel),
        );

      /// search page
      case Routes.search:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => SearchBloc(),
            child: const SearchPage(),
          ),
        );

      /// friend profile page
      case Routes.friendProfile:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => FriendBloc(),
            child: FriendProfilePage(
              uid: arguments['uid'],
            ),
          ),
        );

      /// story config page
      case Routes.storyConfig:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => StoryBloc(),
            child: const StoryConfigPage(),
          ),
        );

      /// image editor page
      case Routes.imageEditor:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ImageEditorPage(
            imagePath: arguments['image_path'],
            bgName: arguments['bg_name'],
          ),
        );

      /// video trimmer page
      case Routes.videoTrimmer:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => VideoTrimmerPage(
            videoPath: arguments['video_path'],
          ),
        );

      /// background selector page
      case Routes.backgroundSelector:
        return MaterialPageRoute(
          builder: (_) => BackgroundSelectorPage(),
        );

      /// story post page
      case Routes.storyPost:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => StoryBloc(),
            child: StoryPostPage(
              filePath: arguments['file_path'],
              type: arguments['type'],
            ),
          ),
        );

      /// post page
      case Routes.post:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => PostBloc(),
            child: PostPage(type: arguments['type'], file: arguments['file']),
          ),
        );

      /// story showcase page
      case Routes.postShowcase:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        PostModel post = arguments['post'] as PostModel;
        bool sameUser = arguments['same_user'] as bool;
        PostVisibilityCubit? postVisibilityCubit = arguments['post_visibility_cubit'];
        PostLikeCubit? postLikeCubit = arguments['post_like_cubit'];
        PostDeleteCubit? postDeleteCubit = arguments['post_delete_cubit'];
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              postVisibilityCubit == null ? BlocProvider(create: (_) => PostVisibilityCubit(post.visibility!)) : BlocProvider.value(value: postVisibilityCubit),
              postLikeCubit == null ? BlocProvider(create: (_) => PostLikeCubit(post.liked)) : BlocProvider.value(value: postLikeCubit),
              postDeleteCubit == null ? BlocProvider(create: (_) => PostDeleteCubit()) : BlocProvider.value(value: postDeleteCubit),
            ],
            child: PostShowcasePage(
              post: post,
              sameUser: sameUser,
            ),
          ),
        );

      /// post comment page
      case Routes.postComment:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => PostCommentBloc(),
            child: PostCommentPage(
              postId: arguments['post_id'],
              autofocus: arguments['autofocus'],
            ),
          ),
        );

      /// story showcase page
      case Routes.storyShowcase:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => StoryShowcasePage(
            story: arguments['story'],
          ),
        );

      /// post list page
      case Routes.postList:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => PostBloc(),
            child: PostListPage(uid: arguments['uid']),
          ),
        );

      /// followers list page
      case Routes.followers:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => FansBloc(),
            child: FollowerListPage(uid: arguments['uid']),
          ),
        );

      /// followings list page
      case Routes.followings:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => FansBloc(),
            child: FollowingListPage(uid: arguments['uid']),
          ),
        );

      /// my friend list page
      case Routes.myFriendList:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => MyFriendListCubit(),
            child: const MyFriendListPage(),
          ),
        );

      /// Secret Chat Page
      case Routes.secretChat:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => SecretChatBloc()),
              BlocProvider(create: (_) => ChatPageCubit()),
              BlocProvider(create: (_) => CanChatCubit((arguments['user'] as UserModel).uid!)),
            ],
            child: SecretChatPage(user: arguments['user']),
          ),
        );

      /// Normal Chat Page
      case Routes.normalChat:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => ChatPageCubit()),
            ],
            child: NormalChatPage(user: arguments['user']),
          ),
        );

      /// Ai Chat Page
      case Routes.aiChat:
        return MaterialPageRoute(builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => ChatPageCubit()),
              BlocProvider(create: (_) => ChattingStatusCubit()),
              BlocProvider(create: (_) => AiChatBloc()),
            ],
            child: const AiChatPage(),
          ),
        );

      /// Setting Page
      case Routes.setting:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        FullProfileModel profileModel = arguments['profile_model'];
        return MaterialPageRoute(builder: (_) => SettingPage(profileModel: profileModel),
        );

      /// blocked user list page
      case Routes.blockUser:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => BlockedUserBloc(),
            child: const BlockedUserPage(),
          ),
        );

      /// change password Page
      case Routes.changePassword:
        return MaterialPageRoute(builder: (_) => BlocProvider(
            create: (_) => PasswordChangeBloc(),
            child: const ChangePasswordPage(),
          ),
        );

      /// change password Page
      case Routes.changeNames:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        FullProfileModel profileModel = arguments['profile_model'];
        ProfileBloc profileBloc = arguments['context_value'];
        return MaterialPageRoute(builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => ChangeNamesBloc()),
              BlocProvider.value(value: profileBloc),
            ],
            child: ChangeNamesPage(profileModel: profileModel),
          ),
        );

      /// report Page
      case Routes.reportUser:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => ReportUserPage(uid: arguments['uid']));

      /// file image viewer Page
      case Routes.fileImageViewer:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => FileImageViewerPage(path: arguments['path']));

        /// web image viewer Page
      case Routes.webImageViewer:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => WebImageViewerPage(source: arguments['source']));

        /// memory image viewer Page
      case Routes.memoryImageViewer:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => MemoryImageViewerPage(bytes: arguments['bytes']));

        /// web video viewer Page
      case Routes.webVideoViewer:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => WebVideoViewerPage(source: arguments['source']));

        /// file video viewer Page
      case Routes.fileVideoViewer:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => FileVideoViewerPage(path: arguments['path']));

      /// camera
      case Routes.camera:
        return MaterialPageRoute(builder: (_) => BlocProvider(
          create: (_) => CameraFeatureCubit(),
          child: const CameraPage(),
        ));

      /// camera
      case Routes.audio:
        return MaterialPageRoute(builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AudioBloc()),
            BlocProvider(create: (_) => SearchBloc()),
          ],
          child: const AudioSelectPage(),
        ));

      /// camera
      case Routes.cameraCaptured:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => CapturedPage(
          type: arguments['type'],
          path: arguments['path'],
        ));

      /// reel post page
      case Routes.reel:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ReelBloc(),
            child: ReelPostPage(file: arguments['file'], audio: arguments['audio']),
          ),
        );

      /// reel slider page
      case Routes.reelSlider:
        return MaterialPageRoute(builder: (_) => const ReelSliderPage());

      /// reel comment page
      case Routes.reelComment:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ReelCommentBloc(),
            child: ReelCommentPage(
              reelId: arguments['reel_id'],
              autofocus: arguments['autofocus'],
            ),
          ),
        );

      /// story showcase page
      case Routes.reelShowcase:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        ReelModel reel = arguments['reel'] as ReelModel;
        bool sameUser = arguments['same_user'] as bool;
        return MaterialPageRoute(
          builder: (_) => ReelShowcasePage(
            reel: reel,
            sameUser: sameUser,
          ),
        );

      /// reel list page
      case Routes.reelList:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ReelBloc(),
            child: ReelListPage(uid: arguments['uid']),
          ),
        );
    }

    /// error page
    return MaterialPageRoute(builder: (context) => const ErrorPage());
  }
}
