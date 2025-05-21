import 'package:flutter/material.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/shared/utilities/pickers.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/shared/console.dart';

class MediaPickerSheet {
  static Future<void> show({
    required BuildContext context,
    required Function(String filePath, String postType) onPicked,
  }) {
    return showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.image, color: AppColors.primaryColor),
                  title: CustomText(
                    title: 'Pick Image',
                    size: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    String? pickedImage = await Pickers.ins.pickImage();
                    console(pickedImage);
                    if (pickedImage != null) {
                      onPicked(pickedImage, 'image');
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.videocam, color: AppColors.primaryColor),
                  title: CustomText(
                    title: 'Pick Video',
                    size: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    String? pickedVideo = await Pickers.ins.pickVideo();
                    console(pickedVideo);
                    if (pickedVideo != null) {
                      onPicked(pickedVideo, 'video');
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }
}
