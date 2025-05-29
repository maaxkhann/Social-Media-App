import 'package:flutter/material.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/extensions/sized_box.dart';

class ExperienceEducation extends StatelessWidget {
  final String image;
  final String heading;
  final String title;
  final String subtitle;
  final String date;
  const ExperienceEducation({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.heading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        21.spaceY,
        Row(
          children: [
            CustomText(title: heading, size: 13, fontWeight: FontWeight.w700),
            Spacer(),
            Icon(
              Icons.add,
              size: 18,
              color: AppColors.black.withValues(alpha: 0.18),
            ),
            12.spaceX,
            Icon(
              Icons.edit,
              size: 18,
              color: AppColors.black.withValues(alpha: 0.18),
            ),
          ],
        ),
        20.spaceY,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 24),
            10.spaceX,
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: title,
                    size: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    title: subtitle,
                    size: 10,
                    color: AppColors.black.withValues(alpha: 0.5),
                  ),
                  3.spaceY,
                  CustomText(title: date, size: 10),
                ],
              ),
            ),
          ],
        ),
        20.spaceY,
        Divider(
          thickness: 4,
          color: AppColors.lightGrey.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}
