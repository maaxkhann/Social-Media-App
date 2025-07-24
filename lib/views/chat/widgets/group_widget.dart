import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/chat_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
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
    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: chatController.groupsOf(chatController.auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final groups = snapshot.data ?? [];

        if (groups.isEmpty) {
          return Center(child: Text("No groups found"));
        }

        return ListView.separated(
          itemCount: groups.length,
          separatorBuilder: (context, index) => 18.spaceY,
          itemBuilder: (context, index) {
            final group = groups[index];
            final groupName = group['name'];
            final groupId = group.id;

            return ListTile(
              onTap: () {
                Get.to(
                  () => GroupChatPage(groupId: groupId, groupName: groupName),
                );
              },
              title: CustomText(
                title: groupName,
                fontWeight: FontWeight.w800,
                size: 14,
              ),
              subtitle: StreamBuilder(
                stream: chatController.chatStream(groupId),
                builder: (context, snap) {
                  if (!snap.hasData || snap.data!.isEmpty) {
                    return Text("No messages yet");
                  }

                  final lastMsg = snap.data!.first;
                  return Row(
                    children: [
                      Text(
                        "${lastMsg['senderName']}: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(
                          lastMsg['text'] ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  );
                },
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://ui-avatars.com/api/?name=${Uri.encodeComponent(groupName)}&background=random",
                ),
              ),
            );
          },
        );
      },
    );
  }
}
