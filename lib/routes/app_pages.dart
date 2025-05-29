import 'package:get/get.dart';
import 'package:social_media/components/custom_bottom_nav_bar.dart';
import 'package:social_media/controllers/post_controller.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:social_media/routes/app_routes.dart';
import 'package:social_media/views/auth/login_view.dart';
import 'package:social_media/views/auth/otp_screen.dart';
import 'package:social_media/views/auth/register_view.dart';
import 'package:social_media/views/auth/splash_view.dart';
import 'package:social_media/views/chat/messages_view.dart';
import 'package:social_media/views/post/full_post_screen.dart';
import 'package:social_media/views/notification/notifications_view.dart';
import 'package:social_media/views/profile/profile_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splashView,
      transition: Transition.rightToLeft,
      page: () => SplashView(),
      // binding: BindingsBuilder(() {
      //   Get.lazyPut<SplashViewModel>(() => SplashViewModel());
      //   // Get.lazyPut<SubsViewModel>(() => SubsViewModel());
      // }),
    ),
    GetPage(
      name: AppRoutes.loginView,
      transition: Transition.rightToLeft,
      page: () => LoginView(),
    ),
    GetPage(
      name: AppRoutes.registerView,
      transition: Transition.rightToLeft,
      page: () => RegisterView(),
    ),
    GetPage(
      name: AppRoutes.otpView,
      transition: Transition.rightToLeft,
      page: () => OtpScreen(),
    ),
    GetPage(
      name: AppRoutes.customBottomNavBar,
      transition: Transition.rightToLeft,
      page: () => CustomBottomNavBar(),
      binding: BindingsBuilder(() {
        Get.put(ProfileController());
        Get.put(PostController());
      }),
    ),
    GetPage(
      name: AppRoutes.notificationsView,
      transition: Transition.rightToLeft,
      page: () => NotificationsView(),
    ),
    GetPage(
      name: AppRoutes.fullPostScreen,
      transition: Transition.fadeIn,
      page: () => FullPostScreen(),
    ),
    GetPage(
      name: AppRoutes.profileView,
      transition: Transition.fadeIn,
      page: () => ProfileView(),
    ),
    GetPage(
      name: AppRoutes.messagesView,
      transition: Transition.fadeIn,
      page: () => MessagesView(),
    ),
  ];
}
