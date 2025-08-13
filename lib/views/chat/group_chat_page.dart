import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/chat_controller.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/shared/timestamp_helper.dart';
import 'package:social_media/views/chat/widgets/chat_appbar.dart';
import 'package:social_media/views/chat/widgets/chat_bottombar.dart';
import 'package:social_media/views/chat/widgets/voice_message_widget.dart';

class GroupChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;

  const GroupChatPage({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final chatController = Get.find<ChatController>();
  final profileController = Get.find<ProfileController>();

  List<String> groupMembers = [];
  @override
  void initState() {
    super.initState();

    firestore.collection('groups').doc(widget.groupId).get().then((doc) {
      setState(() {
        groupMembers = List<String>.from(doc['members'] ?? []);
      });
    });

    // Reset and load initial messages
    chatController.refreshGroupChat(widget.groupId);
    chatController.getGroupMessages(groupId: widget.groupId).then((_) {
      chatController.listenToGroupMessages(
        widget.groupId,
      ); // start realtime updates
    });

    // Scroll listener for pagination
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scrollController = PrimaryScrollController.of(context);
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
                scrollController.position.maxScrollExtent - 200 &&
            !chatController.isLoadingMoreGroupMsgs.value &&
            chatController.hasMoreGroup) {
          chatController.getGroupMessages(groupId: widget.groupId);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        isGroup: true,
        groupId: widget.groupId,
        groupName: widget.groupName,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final messages = chatController.groupMsgList;

              if (chatController.isInitialGroupLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // ✅ Mark unread messages as read
              for (final msg in messages) {
                if (!(msg.readBy ?? []).contains(
                  chatController.auth.currentUser?.uid,
                )) {
                  firestore
                      .collection('groups')
                      .doc(widget.groupId)
                      .collection('messages')
                      .doc(msg.id)
                      .update({
                        'readBy': FieldValue.arrayUnion([
                          chatController.auth.currentUser?.uid,
                        ]),
                      });
                }
              }

              return ListView.separated(
                reverse: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                itemCount: messages.length + 1,
                separatorBuilder: (context, index) => 18.spaceY,
                itemBuilder: (context, index) {
                  if (index == messages.length) {
                    return Center(
                      child:
                          chatController.hasMoreGroup
                              ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const SizedBox.shrink(),
                    );
                  }
                  final msg = messages[index];
                  final isMe =
                      msg.senderId == chatController.auth.currentUser?.uid;
                  final isRead =
                      (msg.readBy?.length ?? 0) >= groupMembers.length;
                  final formattedTime =
                      msg.timeStamp != null
                          ? TimeOfDay.fromDateTime(
                            msg.timeStamp!,
                          ).format(context)
                          : '';
                  final time = msg.timeStamp;

                  // Show date label if first message or day changed
                  String? dateLabel;
                  if (time != null) {
                    // Show label if first message (in reversed list) or day is different from previous message
                    if (index == messages.length - 1 ||
                        (messages[index + 1].timeStamp as Timestamp?)
                                ?.toDate()
                                .day !=
                            time.day) {
                      dateLabel = TimeStampHelper.getMessageDateLabel(time);
                    }
                  }

                  final isVoice =
                      (msg.voiceUrl != null && msg.voiceUrl!.isNotEmpty);

                  return Column(
                    children: [
                      if (dateLabel != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.lightShadeGrey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: CustomText(
                                title: dateLabel,
                                size: 10,
                                color: AppColors.black.withAlpha(150),
                              ),
                            ),
                          ),
                        ),
                      Row(
                        mainAxisAlignment:
                            isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isMe)
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(
                                msg.senderImage ?? '',
                              ),
                            ),
                          if (!isMe) 8.spaceX,
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isMe
                                            ? AppColors.blue
                                            : AppColors.lightShadeGrey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isVoice)
                                        VoiceMessageWidget(
                                          url: msg.voiceUrl ?? '',
                                        )
                                      else
                                        CustomText(
                                          title: msg.text ?? '',
                                          size: 11,
                                          height: 1.2,
                                          color:
                                              isMe
                                                  ? AppColors.white
                                                  : AppColors.black.withAlpha(
                                                    200,
                                                  ),
                                        ),
                                      4.spaceY,
                                      CustomText(
                                        title: formattedTime,
                                        size: 10,
                                        color:
                                            isMe
                                                ? AppColors.white
                                                : AppColors.black.withAlpha(
                                                  200,
                                                ),
                                      ),
                                    ],
                                  ),
                                ),
                                2.spaceY,
                                if (isMe)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 2),
                                    child: Icon(
                                      Icons.check,
                                      size: 12,
                                      color:
                                          isRead
                                              ? AppColors.blue
                                              : AppColors.black,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            }),
          ),

          const Divider(height: 1),
          ChatBottomBar(groupId: widget.groupId, isGroup: true),
        ],
      ),
    );
  }
}
