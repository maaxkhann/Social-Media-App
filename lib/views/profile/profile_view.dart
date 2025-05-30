import 'package:flutter/material.dart';
import 'package:social_media/components/custom_appbar.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/views/profile/widgets/experience_education.dart';
import 'package:social_media/views/profile/widgets/profile_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 12.spaceY,
              // CustomAppBar(),
              34.spaceY,
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
            ],
          ),
        ),
      ),
    );
  }
}
