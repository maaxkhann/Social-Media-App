import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/notifications_controller.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/models/notifications_model.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/routes/app_routes.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final notificationsController = Get.find<NotificationsController>();
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            40.spaceY,
            Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CircleAvatar(
                  radius: 25,
                  foregroundImage: NetworkImage(
                    profileController.userModel.value?.image ??
                        'https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1631&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  ),
                ),
              );
            }),
            Divider(thickness: 3, color: AppColors.lightGrey),
            Expanded(
              child: StreamBuilder(
                stream: notificationsController.getNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: CustomText(
                        title: 'No Notifications yet.',
                        size: 16,
                      ),
                    );
                  }
                  final notifications = snapshot.data;

                  return ListView.separated(
                    itemCount: snapshot.data?.length ?? 0,
                    separatorBuilder: (context, index) => 4.spaceY,
                    itemBuilder: (context, index) {
                      final notification = notifications?[index];
                      return GestureDetector(
                        onTap: () async {
                          PostModel? postModel = await notificationsController
                              .markNotificationAsRead(
                                notification.notificationId!,
                                notification.postId!,
                              );
                          if (postModel != null) {
                            navigationControl(notification, postModel);
                          }
                        },

                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              notification!.isRead! ? 0 : 8,
                            ),
                            color:
                                notification.isRead!
                                    ? AppColors.white
                                    : AppColors.lightGrey,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              foregroundImage: NetworkImage(
                                notification.senderImage ?? '',
                              ),
                            ),
                            title: Text.rich(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: notification.senderName ?? '',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: buildNotificationMessage(
                                      notification,
                                    ),
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            trailing: FittedBox(
                              child: CustomText(
                                title: timeago.format(notification.timestamp!),
                                size: 10,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String buildNotificationMessage(NotificationModel notification) {
    switch (notification.type) {
      case 'like':
        return ' ${notification.message!}';
      case 'like_comment':
        return ' ${notification.message!}';
      case 'comment':
        return ' ${notification.message!}';
      case 'reply':
        return ' ${notification.message!}';
      case 'follow':
        return ' ${notification.message!}';
      case 'unfollow':
        return ' ${notification.message!}';
      default:
        return ' sent you a notification';
    }
  }

  navigationControl(NotificationModel notification, PostModel post) {
    switch (notification.type) {
      case 'comment':
        if (notification.postId != null) {
          Get.toNamed(
            AppRoutes.fullPostScreen,
            arguments: {'post': post, 'commentId': notification.commentId},
          );
        }
        break;
      case 'reply':
        if (notification.postId != null) {
          Get.toNamed(
            AppRoutes.fullPostScreen,
            arguments: {'post': post, 'commentId': notification.commentId},
          );
        }
        break;
      case 'like':
        if (notification.postId != null) {
          Get.toNamed(AppRoutes.fullPostScreen, arguments: {'post': post});
        }
        break;
      case 'like_comment':
        if (notification.postId != null) {
          Get.toNamed(
            AppRoutes.fullPostScreen,
            arguments: {'post': post, 'commentId': notification.commentId},
          );
        }
        break;

      // case 'follow':
      //   if (notification.senderId != null) {
      //     Get.toNamed('/user-profile', arguments: {
      //       'userId': notification.senderId,
      //     });
      //   }
      //z  break;
      default:
        break;
    }
  }
}
