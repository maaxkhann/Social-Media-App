import 'package:flutter/material.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/extensions/sized_box.dart';

class DocUploadContainer extends StatelessWidget {
  const DocUploadContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 23, bottom: 15, left: 35, right: 35),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.black.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.upload,
            size: 18,
            color: AppColors.black.withValues(alpha: 0.5),
          ),
          10.spaceY,
          CustomText(
            title: 'Upload your Resume ,Doc1,Doc2',
            size: 12,

            color: AppColors.black.withValues(alpha: 0.5),
          ),
          5.spaceY,
          CustomText(
            title: 'Formate should pdf or docx.',
            size: 10,

            color: AppColors.black.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
