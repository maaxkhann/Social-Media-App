import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/components/custom_textfield.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/controllers/chat_controller.dart';

class ChatBottomBar extends StatelessWidget {
  final String otherUserId;
  const ChatBottomBar({super.key, required this.otherUserId});
  static final chatCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatController = Get.put(ChatController());
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: chatCont,
              isBorder: false,
              hintText: 'Message...',
              suffixIcon: IconButton(
                onPressed: () {
                  chatController
                      .sendMessage(
                        currentUserId: chatController.auth.currentUser!.uid,
                        otherUserId: otherUserId,
                        messageText: chatCont.text,
                      )
                      .then((val) => chatCont.clear());
                },
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
