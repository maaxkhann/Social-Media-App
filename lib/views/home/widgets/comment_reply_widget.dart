import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/components/custom_textfield.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/notifications_controller.dart';
import 'package:social_media/controllers/post_controller.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/models/comments_model.dart';
import 'package:social_media/shared/console.dart';

class CommentReplyWidget extends StatefulWidget {
  final CommentsModel comment;
  final Function(bool) isFocus;

  const CommentReplyWidget({
    super.key,
    required this.comment,
    required this.isFocus,
  });

  @override
  State<CommentReplyWidget> createState() => _CommentWithRepliesWidgetState();
}

class _CommentWithRepliesWidgetState extends State<CommentReplyWidget> {
  final TextEditingController replyController = TextEditingController();
  bool showReplyInput = false;
  final postController = Get.find<PostController>();
  final notificationsController = Get.find<NotificationsController>();
  final profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Comment UI
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  4.spaceX,
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            postController.likeComment(
                              comment.commentId,
                              comment.postId,
                              !comment.isLiked,
                            );
                          },
                          child: CustomText(
                            title: comment.isLiked ? 'Unlike' : 'Like',
                            size: 10,
                          ),
                        ),
                        11.spaceX,
                        CustomText(
                          title: '.',
                          size: 10,
                          color: AppColors.black.withValues(alpha: 0.5),
                        ),
                        11.spaceX,
                        Icon(
                          comment.isLiked
                              ? Icons.thumb_up
                              : Icons.thumb_up_outlined,
                          color: AppColors.blue,
                          size: 9,
                        ),
                        3.spaceX,
                        Obx(() {
                          return CustomText(
                            title:
                                '${postController.commentsLikesCount[comment.commentId] ?? '0'}',
                            size: 10,
                          );
                        }),
                        12.spaceX,
                        InkWell(
                          onTap: () {
                            widget.isFocus(true);
                            postController.setAutoFocus(true);
                            postController.replyingToCommentId.value =
                                comment.commentId;
                            setState(() {
                              showReplyInput = !showReplyInput;
                              console('showRpppppppp $showReplyInput');
                            });
                          },
                          child: CustomText(title: 'Reply', size: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Replies
        if (showReplyInput)
          StreamBuilder(
            stream: notificationsController.getRepliesStream(comment.commentId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              final replies = snapshot.data!;
              return ListView.builder(
                itemCount: replies.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 30),
                itemBuilder: (context, index) {
                  final reply = replies[index];
                  return Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(
                              reply.user?.image ?? '',
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                top: 6,
                                left: 9,
                                right: 25,
                              ),
                              padding: EdgeInsets.only(
                                left: 12,
                                right: 12,
                                top: 7,
                                bottom: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    title: reply.user?.name ?? '',
                                    size: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  2.spaceY,
                                  CustomText(
                                    title: reply.user?.position ?? '',
                                    size: 8,
                                    color: AppColors.black.withValues(
                                      alpha: 0.9,
                                    ),
                                  ),
                                  6.spaceY,
                                  CustomText(title: reply.reply, size: 8),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      4.spaceY,
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                postController.likeCommentReply(
                                  comment.commentId,
                                  reply.replyId,
                                  comment.postId,
                                  !reply.isLiked,
                                );
                              },
                              child: CustomText(
                                title: reply.isLiked ? 'Unlike' : 'Like',
                                size: 10,
                              ),
                            ),
                            11.spaceX,
                            CustomText(
                              title: '.',
                              size: 10,
                              color: AppColors.black.withValues(alpha: 0.5),
                            ),
                            11.spaceX,
                            Icon(
                              reply.isLiked
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_outlined,
                              color: AppColors.blue,
                              size: 9,
                            ),
                            3.spaceX,
                            Obx(() {
                              return CustomText(
                                title:
                                    '${postController.commentsReplyLikesCount[reply.replyId] ?? '0'}',
                                size: 10,
                              );
                            }),
                            12.spaceX,
                            InkWell(
                              onTap: () {
                                // widget.isFocus(true);
                                // postController.setAutoFocus(true);
                                // postController.replyingToCommentId.value =
                                //     comment.commentId;
                                // setState(() {
                                //   showReplyInput = !showReplyInput;
                                //   console('showRpppppppp $showReplyInput');
                                // });
                              },
                              child: CustomText(title: 'Reply', size: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        8.spaceY,
      ],
    );
  }
}
