import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/shared/console.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final profileController = ProfileController();
  @override
  void initState() {
    profileController.getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    console('asldkj ${profileController.userModel.value?.name}');
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 38,
            foregroundImage: NetworkImage(
              profileController.userModel.value?.image ?? '',
            ),
          ),
          10.spaceX,
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: profileController.userModel.value?.name ?? '',
                  size: 20,
                  fontWeight: FontWeight.w700,
                ),
                4.spaceY,
                CustomText(
                  title: profileController.userModel.value?.position ?? '',
                  size: 12,
                ),
                5.spaceY,
                CustomText(
                  title:
                      'Comsatsuniversity, ABottabad campus Nowshera Kpk,Pakistan',
                  size: 11,
                  color: AppColors.black.withValues(alpha: 0.5),
                ),
                8.spaceY,
                Row(
                  children: [
                    CustomText(
                      title:
                          '${profileController.followersCount.value} Followers',
                      size: 12,
                      color: AppColors.blue,
                      fontWeight: FontWeight.w700,
                    ),
                    12.spaceX,
                    CustomText(
                      title: '*',
                      size: 12,
                      color: AppColors.black.withValues(alpha: 0.5),
                    ),
                    5.spaceX,
                    CustomText(
                      title:
                          '${profileController.followersCount.value} Following',
                      size: 12,
                      color: AppColors.black.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          Icon(
            Icons.edit,
            size: 18,
            color: AppColors.black.withValues(alpha: 0.18),
          ),
        ],
      );
    });
  }
}
