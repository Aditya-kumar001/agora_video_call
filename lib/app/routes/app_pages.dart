import 'package:get/get.dart';

import '../modules/audio_calling/bindings/audio_calling_binding.dart';
import '../modules/audio_calling/views/audio_calling_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/incomming_call/bindings/incomming_call_binding.dart';
import '../modules/incomming_call/views/incomming_call_view.dart';
import '../modules/invitation/bindings/invitation_binding.dart';
import '../modules/invitation/views/invitation_view.dart';
import '../modules/login_page/bindings/login_page_binding.dart';
import '../modules/login_page/views/login_page_view.dart';
import '../modules/message_view/bindings/message_view_binding.dart';
import '../modules/message_view/views/message_view_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/search_user/bindings/search_user_binding.dart';
import '../modules/search_user/views/search_user_view.dart';
import '../modules/video_calling/bindings/video_calling_binding.dart';
import '../modules/video_calling/views/video_calling_view.dart';
import '../widgets/common_bottom_navigation.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN_PAGE;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => CustomBottomNavigation(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_PAGE,
      page: () => const LoginPageView(),
      binding: LoginPageBinding(),
    ),
    GetPage(
      name: _Paths.MESSAGE_VIEW,
      page: () => const MessageViewView(),
      binding: MessageViewBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_USER,
      page: () => const SearchUserView(),
      binding: SearchUserBinding(),
    ),
    GetPage(
      name: _Paths.INVITATION,
      page: () => InvitationView(),
      binding: InvitationBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO_CALLING,
      page: () => const VideoCallingView(),
      binding: VideoCallingBinding(),
    ),
    GetPage(
      name: _Paths.AUDIO_CALLING,
      page: () => const AudioCallingView(),
      binding: AudioCallingBinding(),
    ),
    GetPage(
      name: _Paths.INCOMMING_CALL,
      page: () => const IncommingCallView(),
      binding: IncommingCallBinding(),
    ),
  ];
}
