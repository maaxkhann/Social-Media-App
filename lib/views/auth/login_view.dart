import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/components/custom_textfield.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_spacing.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/auth_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/routes/app_routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final authController = Get.put(AuthController());
  final emailCont = TextEditingController();
  final passwordCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: AppSpacing.authSpacing,
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              title: 'Welcome',
              size: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
            CustomText(
              title: 'Sign in to your account',

              color: AppColors.black.withValues(alpha: 0.5),
            ),
            18.spaceY,
            CustomTextField(
              controller: emailCont,
              hintText: 'example@gmail.com',
              keyboardType: TextInputType.emailAddress,
            ),
            CustomTextField(
              controller: passwordCont,
              hintText: '******',
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: CustomText(
                title: 'Forgot Password?',
                color: AppColors.primaryColor.withValues(alpha: 0.5),
              ),
            ),
            18.spaceY,
            GestureDetector(
              onTap:
                  () => authController.loginUser(
                    emailCont.text,
                    passwordCont.text,
                  ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: CustomText(title: 'Login', color: AppColors.white),
                ),
              ),
            ),

            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Dont have account? ',
                    style: TextStyle(
                      color: AppColors.primaryColor.withValues(alpha: 0.5),
                    ),
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sign Up!',
                        style: TextStyle(
                          color: AppColors.primaryColor.withValues(alpha: 0.5),
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap =
                                  () => Get.toNamed(AppRoutes.registerView),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
