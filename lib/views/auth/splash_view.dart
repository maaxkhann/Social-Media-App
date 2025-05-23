import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/routes/app_routes.dart';
import 'package:social_media/shared/console.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  startAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward().whenComplete(() => checkUser());
  }

  void checkUser() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final isLogin = sp.getBool('isLogin') ?? false;

      if (isLogin) {
        Get.offNamed(AppRoutes.customBottomNavBar);
      } else {
        Get.offNamed(AppRoutes.loginView);
      }
    } catch (e) {
      console('SharedPreferences error: $e');
      Get.offNamed(AppRoutes.loginView);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/splash_icon.png',
                  width: 181,
                  height: 170,
                  fit: BoxFit.contain,
                ),
                4.spaceY,
                CustomText(
                  title: 'Lets grow together',
                  size: 18,
                  color: AppColors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 88,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 37),
                child: LinearProgressIndicator(
                  value: _animation.value,
                  backgroundColor: AppColors.lightGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
