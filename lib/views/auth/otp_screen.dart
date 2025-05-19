import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:social_media/components/custom_appbar.dart';
import 'package:social_media/components/custom_textfield.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_spacing.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/extensions/build_context.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/routes/app_routes.dart';
import 'package:social_media/views/auth/register_view.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController controller = TextEditingController();
  late final PinTheme defaultPinTheme;
  late final PinTheme focusedPinTheme;
  late final PinTheme submittedPinTheme;
  @override
  void initState() {
    super.initState();
    defaultPinTheme = PinTheme(
      width: 48,
      height: 52,
      textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.black.withValues(alpha: 0.25)),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.black.withValues(alpha: 0.25)),
      borderRadius: BorderRadius.circular(10),
    );

    submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColors.black.withValues(alpha: 0.25)),
      ),
    );
  }

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
              16.spaceY,
              CustomText(
                title: 'Verify your Account',
                size: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
              CustomText(
                size: 11,
                title:
                    'Please type verification code sent to\n example@gmail.com',

                color: AppColors.black.withValues(alpha: 0.5),
                alignment: TextAlign.center,
              ),
              18.spaceY,
              Pinput(
                controller: controller,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
              ),
              9.spaceY,
              CustomText(
                title: '01:25',

                color: AppColors.black.withValues(alpha: 0.5),
              ),
              9.spaceY,
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: CustomText(title: 'VERIFY', color: AppColors.white),
                  ),
                ),
              ),

              CustomText(
                title: 'Resend Code',
                size: 12,
                color: AppColors.primaryColor.withValues(alpha: 0.56),
                alignment: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
