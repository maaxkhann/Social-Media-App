import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:social_media/extensions/sized_box.dart';

class StoriesList extends StatelessWidget {
  const StoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              foregroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1631&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ),
            ),

            12.spaceX,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: 'Kashif Ahmad',
                  size: 13,
                  fontWeight: FontWeight.w800,
                ),
                6.spaceY,
                CustomText(title: 'Today at 4:16 PM', size: 10),
              ],
            ),
            Spacer(),
            CustomText(
              title: 'Recent',
              size: 10,
              color: AppColors.yellow,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ],
    );
  }
}
