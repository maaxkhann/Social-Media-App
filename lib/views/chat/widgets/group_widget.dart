import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/chat_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/models/group_messages_model.dart';
import 'package:social_media/models/group_model.dart';
import 'package:social_media/views/chat/group_chat_page.dart';

class GroupWidget extends StatefulWidget {
  const GroupWidget({super.key});

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  final chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GroupModel>>(
      stream: chatController.groupsOf(chatController.auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final groups = snapshot.data ?? [];

        if (groups.isEmpty) {
          return const Center(child: CustomText(title: "No groups found"));
        }

        return ListView.separated(
          itemCount: groups.length,
          separatorBuilder: (context, index) => 18.spaceY,
          itemBuilder: (context, index) {
            final group = groups[index];

            return Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Get.to(
                      () => GroupChatPage(
                        groupId: group.id,
                        groupName: group.name,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: StreamBuilder(
                      stream: chatController.chatStream(group.id),
                      builder: (context, snap) {
                        final lastMsg =
                            snap.data?.first ?? GroupMessagesModel();

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  foregroundImage: NetworkImage(
                                    "https://ui-avatars.com/api/?name=${Uri.encodeComponent(group.name)}&background=random",
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
                                    title: group.name,
                                    size: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  CustomText(
                                    title:
                                        (lastMsg.text?.isNotEmpty ?? false)
                                            ? "${lastMsg.senderName}: ${lastMsg.text}"
                                            : "${lastMsg.senderName}: Voice message",
                                    size: 11,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                // Optional: You can add a time stamp here if needed
                                5.spaceY,
                                CustomText(
                                  title:
                                      lastMsg.timeStamp != null
                                          ? TimeOfDay.fromDateTime(
                                            lastMsg.timeStamp!,
                                          ).format(context)
                                          : '',
                                  size: 10,
                                  color: AppColors.yellow,
                                  fontWeight: FontWeight.w700,
                                ),
                                5.spaceY,
                                if ((group.unReadCount) > 0)
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundColor: AppColors.yellow,
                                    child: CustomText(
                                      title: group.unReadCount.toString(),
                                      size: 12,
                                      color: AppColors.white,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
