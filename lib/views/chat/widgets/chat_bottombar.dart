import 'package:flutter/material.dart';
import 'package:social_media/components/custom_textfield.dart';
import 'package:social_media/constants/app_colors.dart';

class ChatBottomBar extends StatelessWidget {
  const ChatBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              isBorder: false,
              hintText: 'Message...',
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.send, color: AppColors.yellow),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  iconSize: 20,
                  visualDensity: VisualDensity.compact,
                  onPressed: () {},
                  icon: Icon(
                    Icons.camera_alt,
                    color: AppColors.black.withValues(alpha: 0.5),
                  ),
                ),
                IconButton(
                  iconSize: 20,
                  visualDensity: VisualDensity.compact,
                  onPressed: () {},
                  icon: Icon(
                    Icons.mic,
                    color: AppColors.black.withValues(alpha: 0.5),
                  ),
                ),
                IconButton(
                  iconSize: 20,
                  visualDensity: VisualDensity.compact,
                  onPressed: () {},
                  icon: Icon(
                    Icons.attachment_outlined,
                    color: AppColors.black.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
