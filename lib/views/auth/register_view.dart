import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/components/custom_appbar.dart';
import 'package:social_media/components/custom_textfield.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_spacing.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/auth_controller.dart';
import 'package:social_media/extensions/build_context.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/routes/app_routes.dart';
import 'package:social_media/shared/utilities/pickers.dart';
import 'package:social_media/views/auth/widgets/doc_upload_container.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final authController = Get.find<AuthController>();
  final nameCont = TextEditingController();
  final emailCont = TextEditingController();
  final phoneCont = TextEditingController();
  final positionCont = TextEditingController();
  final passwordCont = TextEditingController();
  final confirmPasswordCont = TextEditingController();

  String? image;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: AppSpacing.authSpacing,
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomAppBar(),
              CustomText(
                title: 'Create Account',
                size: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
              GestureDetector(
                onTap: () async {
                  String? pickedImage = await Pickers.ins.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedImage != null) {
                    image = pickedImage;
                    setState(() {});
                  }
                },
                child: CircleAvatar(
                  radius: 40,
                  foregroundImage:
                      image != null
                          ? FileImage(File(image!))
                          : NetworkImage(
                            'https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1631&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                          ),
                ),
              ),

              // 18.spaceY,
              CustomTextField(controller: nameCont, hintText: 'Username'),
              CustomTextField(
                controller: emailCont,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextField(controller: phoneCont, hintText: 'Phone number'),
              CustomTextField(hintText: 'Position', controller: positionCont),
              CustomTextField(
                controller: passwordCont,
                hintText: 'Password',
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
              ),
              CustomTextField(
                controller: confirmPasswordCont,
                hintText: 'Confirm Password',
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
              ),
              10.spaceY,
              DocUploadContainer(),

              12.spaceY,
              GestureDetector(
                onTap:
                    () => authController.createUser(
                      image ?? '',
                      nameCont.text,
                      passwordCont.text,
                      emailCont.text,
                      phoneCont.text,
                      positionCont.text,
                    ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: CustomText(title: 'SIGNUP', color: AppColors.white),
                  ),
                ),
              ),

              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Have an account? ',
                      style: TextStyle(
                        color: AppColors.primaryColor.withValues(alpha: 0.5),
                      ),
                    ),
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Login here!',
                          style: TextStyle(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap =
                                    () => Get.offNamed(AppRoutes.loginView),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
