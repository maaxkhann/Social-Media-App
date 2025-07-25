import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/components/custom_appbar.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/routes/app_routes.dart';
import 'package:social_media/views/profile/widgets/experience_education.dart';
import 'package:social_media/views/profile/widgets/profile_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 12.spaceY,
              // CustomAppBar(),
              4.spaceY,
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  color: AppColors.primaryColor,
                  onPressed: () async {
                    final sp = await SharedPreferences.getInstance();
                    sp
                        .setBool('isLogin', false)
                        .then(
                          (value) => Get.offNamedUntil(
                            AppRoutes.loginView,
                            (route) =>
                                route.settings.name == AppRoutes.loginView,
                          ),
                        );
                  },
                  icon: Icon(Icons.logout),
                ),
              ),
              4.spaceY,
              ProfileWidget(),
              20.spaceY,
              Divider(
                thickness: 4,
                color: AppColors.lightGrey.withValues(alpha: 0.5),
              ),
              22.spaceY,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    title: 'About',
                    size: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  Icon(
                    Icons.edit,
                    size: 18,
                    color: AppColors.black.withValues(alpha: 0.18),
                  ),
                ],
              ),
              20.spaceY,
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: CustomText(
                  title:
                      'Business analysts identify business areas that can be improved to increase efficiency and strengthen business processes. They often work closely with others throughout the business hierarchy to communicate their findings and help implement changes',
                  size: 10,
                  color: AppColors.black.withValues(alpha: 0.5),
                ),
              ),
              20.spaceY,
              Divider(
                thickness: 4,
                color: AppColors.lightGrey.withValues(alpha: 0.5),
              ),

              ExperienceEducation(
                image: '',
                heading: 'Experience',

                title: 'Bussiness Analyst',
                subtitle: 'Comsatsuniversity, ABottabad',
                date: 'May 2023 - Present',
              ),
              ExperienceEducation(
                image: '',
                heading: 'Education',
                title: 'BS- Bussiness',
                subtitle: 'Comsatsuniversity, Abottabad',
                date: 'May 2019 - May 2023',
              ),
              12.spaceY,
            ],
          ),
        ),
      ),
    );
  }
}
