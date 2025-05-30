import 'package:flutter/material.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/extensions/sized_box.dart';

class GroupWidget extends StatelessWidget {
  const GroupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  foregroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1631&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  ),
                ),

                Positioned(
                  bottom: 5,
                  right: 1,
                  child: CircleAvatar(
                    radius: 6,
                    backgroundColor: AppColors.yellow,
                  ),
                ),
              ],
            ),
            12.spaceX,
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: 'Buisness Ideas',
                    size: 13,
                    fontWeight: FontWeight.w800,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title: 'Rashid: ',
                        size: 13,
                        fontWeight: FontWeight.w800,
                      ),
                      Expanded(
                        child: CustomText(
                          title:
                              'Hi Iike your work which is very amazing want to know more...',
                          size: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Column(
              children: [
                CustomText(
                  title: '10:44 PM',
                  size: 10,
                  color: AppColors.yellow,
                  fontWeight: FontWeight.w700,
                ),
                5.spaceY,
                CircleAvatar(
                  radius: 10,
                  backgroundColor: AppColors.yellow,
                  child: CustomText(
                    title: '1',
                    size: 12,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
