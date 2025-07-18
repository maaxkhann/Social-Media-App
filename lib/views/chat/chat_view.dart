import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/chat_controller.dart';
import 'package:social_media/controllers/post_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/views/chat/widgets/chat_appbar.dart';
import 'package:social_media/views/chat/widgets/chat_bottombar.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final chatController = Get.put(ChatController());
  String chatId = '';
  @override
  void initState() {
    chatId = chatController.channelId(
      chatController.auth.currentUser!.uid,
      Get.arguments[0],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatController = Get.put(ChatController());
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: ChatAppBar(),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: chatController.getMessages(chatId: chatId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!;
                  return ListView.separated(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 18,
                    ),
                    itemCount: messages.length,
                    separatorBuilder: (_, __) => 18.spaceY,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMine =
                          message['senderId'] ==
                          chatController.auth.currentUser!.uid;
                      final text = message['text'] ?? '';
                      final time =
                          (message['timestamp'] as Timestamp?)?.toDate();
                      final formattedTime =
                          time != null
                              ? TimeOfDay.fromDateTime(time).format(context)
                              : '';

                      return Row(
                        children: [
                          // isMine
                          //     ? const SizedBox.shrink()
                          //     : const CircleAvatar(radius: 18),
                          //  13.spaceX,
                          Expanded(
                            child: Align(
                              alignment:
                                  isMine
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      isMine
                                          ? AppColors.blue
                                          : AppColors.lightShadeGrey,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                      title: text,
                                      size: 11,
                                      color:
                                          isMine
                                              ? AppColors.white
                                              : AppColors.black.withAlpha(200),
                                    ),
                                    2.spaceY,
                                    CustomText(
                                      title: formattedTime,
                                      size: 10,
                                      color:
                                          isMine
                                              ? AppColors.white
                                              : AppColors.black.withAlpha(200),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            ChatBottomBar(otherUserId: Get.arguments[0]),
          ],
        ),
      ),
    );
  }
}
