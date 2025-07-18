import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/chat_controller.dart';
import 'package:social_media/extensions/sized_box.dart';

class MessagesWidget extends StatefulWidget {
  const MessagesWidget({super.key});

  @override
  State<MessagesWidget> createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {
  final chatController = Get.put(ChatController());
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatController.getUserChats(chatController.auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          itemCount: snapshot.data!.length,
          separatorBuilder: (context, index) => 18.spaceY,
          itemBuilder: (context, index) {
            final chat = snapshot.data![index];
            final isGroup = chat['isGroup'] ?? false;
            final name = isGroup ? chat['groupName'] : chat['otherUserId'];
            final message = chat['lastMessage'] ?? '';
            final timestamp =
                (chat['lastMessageTimestamp'] as Timestamp?)?.toDate();
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
                            title: name,
                            size: 13,
                            fontWeight: FontWeight.w700,
                          ),
                          CustomText(title: message, size: 11),
                        ],
                      ),
                    ),
                    Spacer(),
                    Column(
                      children: [
                        CustomText(
                          title:
                              timestamp != null
                                  ? TimeOfDay.fromDateTime(
                                    timestamp,
                                  ).format(context)
                                  : 'null',
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
          },
        );
      },
    );
  }
}
