import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/chat_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/routes/app_routes.dart';

class MessagesWidget extends StatefulWidget {
  const MessagesWidget({super.key});

  @override
  State<MessagesWidget> createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget>
    with WidgetsBindingObserver {
  final chatController = Get.put(ChatController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setOnlineStatus(true); // user opened the app
  }

  void _setOnlineStatus(bool status) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(chatController.auth.currentUser!.uid)
        .update({'isOnline': status});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      _setOnlineStatus(false); // app in background
    } else if (state == AppLifecycleState.resumed) {
      _setOnlineStatus(true); // app resumed
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatController.getUserChats(chatController.auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: const CustomText(title: "No data"));
        }
        return ListView.separated(
          itemCount: snapshot.data!.length,
          separatorBuilder: (context, index) => 18.spaceY,
          itemBuilder: (context, index) {
            final chatUser = snapshot.data![index];

            return Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap:
                      () => Get.toNamed(
                        AppRoutes.chatView,
                        arguments: [chatUser.otherUserId],
                      ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StreamBuilder<DocumentSnapshot>(
                          stream:
                              FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(chatUser.otherUserId)
                                  .snapshots(),
                          builder: (context, snapshot) {
                            final isOnline =
                                snapshot.data?.get('isOnline') ?? false;

                            return Stack(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  foregroundImage: NetworkImage(
                                    chatUser.user?.image ?? 'default_image_url',
                                  ),
                                ),
                                if (isOnline)
                                  Positioned(
                                    bottom: 5,
                                    right: 1,
                                    child: CircleAvatar(
                                      radius: 6,
                                      backgroundColor: AppColors.yellow,
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        12.spaceX,
                        Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                title: chatUser.user?.name ?? '',
                                size: 13,
                                fontWeight: FontWeight.w700,
                              ),
                              CustomText(
                                title:
                                    (chatUser.lastMessage?.isNotEmpty ?? false)
                                        ? chatUser.lastMessage!
                                        : 'voice message',
                                maxLine: 1,
                                size: 11,
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Column(
                          children: [
                            CustomText(
                              title:
                                  chatUser.lastMessageTimestamp != null
                                      ? TimeOfDay.fromDateTime(
                                        chatUser.lastMessageTimestamp!,
                                      ).format(context)
                                      : '',
                              size: 10,
                              color: AppColors.yellow,
                              fontWeight: FontWeight.w700,
                            ),
                            5.spaceY,
                            if ((chatUser.unreadCount ?? 0) > 0)
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: AppColors.yellow,
                                child: CustomText(
                                  title: chatUser.unreadCount.toString(),
                                  size: 12,
                                  color: AppColors.white,
                                ),
                              ),
                          ],
                        ),
                      ],
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
