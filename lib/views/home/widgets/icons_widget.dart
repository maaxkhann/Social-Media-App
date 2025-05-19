import 'package:flutter/material.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/extensions/sized_box.dart';

class IconsWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isLiked;
  final VoidCallback? onTap;
  const IconsWidget({
    super.key,
    required this.title,
    this.isLiked = false,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Icon(
            icon,
            size: 12.5,
            color:
                isLiked
                    ? AppColors.blue
                    : AppColors.black.withValues(alpha: 0.65),
          ),
        ),
        5.spaceY,
        CustomText(title: title, size: 10),
      ],
    );
  }
}
