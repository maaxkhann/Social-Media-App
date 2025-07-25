import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/chat_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/models/chat_model.dart';
import 'package:social_media/views/chat/widgets/chat_appbar.dart';
import 'package:social_media/views/chat/widgets/chat_bottombar.dart';
import 'package:social_media/views/chat/widgets/voice_message_widget.dart';

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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: ChatAppBar(),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<ChatModel>>(
                stream: chatController.getMessages(chatId: chatId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!;
                  // Mark unread messages as read if they're not sent by me
                  final unread =
                      messages
                          .where(
                            (msg) =>
                                !msg.read &&
                                msg.senderId !=
                                    chatController.auth.currentUser!.uid,
                          )
                          .toList();

                  if (unread.isNotEmpty) {
                    chatController.markMessagesAsRead(
                      chatId,
                      chatController.auth.currentUser!.uid,
                    );
                  }
                  return ListView.separated(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),
                    itemCount: messages.length,
                    separatorBuilder: (_, __) => 18.spaceY,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMine =
                          message.senderId ==
                          chatController.auth.currentUser!.uid;
                      final isVoice =
                          message.voiceUrl != null &&
                          message.voiceUrl!.isNotEmpty;

                      final time = (message.timestamp as Timestamp?)?.toDate();
                      final formattedTime =
                          time != null
                              ? TimeOfDay.fromDateTime(time).format(context)
                              : '';

                      return Align(
                        alignment:
                            isMine
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isVoice ? 4 : 8,
                                vertical: isVoice ? 4 : 8,
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
                                  if (isVoice)
                                    VoiceMessageWidget(url: message.voiceUrl!)
                                  else
                                    CustomText(
                                      title: message.text,
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
                            if (isMine)
                              Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Icon(
                                  Icons.check,
                                  size: 12,
                                  color:
                                      message.read
                                          ? AppColors.blue
                                          : AppColors.black,
                                ),
                              ),
                          ],
                        ),
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
