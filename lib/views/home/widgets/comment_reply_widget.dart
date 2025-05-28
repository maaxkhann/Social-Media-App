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

        // if (showReplyInput) ...[
        //   SafeArea(
        //     child: Padding(
        //       padding: EdgeInsets.only(left: 50, right: 50, top: 4),
        //       child: CustomTextField(
        //         controller: replyController,
        //         hintText: 'Write a reply...',
        //         suffixIcon: IconButton(
        //           icon: const Icon(Icons.send),
        //           onPressed: () async {
        //             final replyText = replyController.text.trim();
        //             if (replyText.isNotEmpty) {
        //               await notificationsController.addReply(
        //                 comment.commentId,
        //                 replyText,
        //               );
        //               replyController.clear();
        //               setState(() => showReplyInput = false);
        //             }
        //           },
        //         ),
        //       ),
        //     ),
        //   ),
        //   SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        // ],

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
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(
                            reply.user?.image ?? '',
                          ),
                        ),
                        8.spaceX,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                title: reply.user?.name ?? '',
                                size: 11,
                                fontWeight: FontWeight.w500,
                              ),
                              CustomText(title: reply.reply, size: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
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
