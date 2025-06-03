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
import 'package:social_media/views/home/widgets/comment_reply_widget.dart';
import 'package:social_media/views/home/widgets/comments_widget.dart';

showCommentSheet(
  BuildContext context,
  String postId, {
  String? targetCommentId,
}) {
  final commentController = TextEditingController();
  final postController = Get.find<PostController>();

  final notificationsController = Get.find<NotificationsController>();
  final commentStream = postController.getComments(postId);
  bool autoFocus = false;
  final scrollController = ScrollController();
  final Map<String, GlobalKey> commentKeys = {};

  scrollController.addListener(() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 300) {
      postController.loadMoreComments(postId);
    }
  });
  postController.loadInitialComments(postId);

  showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    builder: (context) {
      return GestureDetector(
        onTap: () {
          postController.autoFocus.value = false;
          postController.replyingToCommentId.value = null;
        },
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 30,
            left: 12,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  12.spaceY,
                  CustomText(
                    title: 'Comments',
                    size: 10,
                    fontWeight: FontWeight.w700,
                  ),
                  19.spaceY,
                  Expanded(
                    child: Obx(() {
                      final comments = postController.paginatedComments;
                      final isLoading = postController.isCommentsLoading.value;
                      if (isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (comments.isEmpty) {
                        return const Center(
                          child: CustomText(
                            title: 'No comments yet.',
                            size: 16,
                          ),
                        );
                      }
                      return StatefulBuilder(
                        builder: (context, setState) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (targetCommentId != null &&
                                commentKeys[targetCommentId]?.currentContext !=
                                    null) {
                              Scrollable.ensureVisible(
                                commentKeys[targetCommentId]!.currentContext!,
                                duration: Duration(milliseconds: 400),
                                // alignment: 0.02, // controls how high in the view it lands
                              );
                            }
                          });
                          return CommentsWidget(
                            scrollController: scrollController,
                            comments: comments,
                            commentKeys: commentKeys,
                          );
                        },
                      );
                    }),
                  ),
                  SizedBox(height: Get.height * 0.09),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Obx(() {
                    return CustomTextField(
                      controller: commentController,
                      fillColor: AppColors.primaryColor,
                      hintColor: AppColors.white,
                      autoFocus: autoFocus,

                      hintText:
                          postController.autoFocus.value
                              ? 'Write a reply...'
                              : 'Add comment',
                      suffixIcon: IconButton(
                        onPressed: () async {
                          final text = commentController.text.trim();
                          if (text.isNotEmpty) {
                            if (postController.autoFocus.value &&
                                postController.replyingToCommentId.value !=
                                    null) {
                              await notificationsController.addReply(
                                postController.replyingToCommentId.value!,
                                text,
                              );
                            } else {
                              postController.addComment(postId, text);
                            }
                            commentController.clear();
                            postController.autoFocus.value = false;
                            postController.replyingToCommentId.value = null;
                          }
                        },

                        icon: Icon(Icons.send, color: AppColors.white),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      );
    },
  ).whenComplete(() {
    postController.setAutoFocus(false);
    postController.replyingToCommentId.value = null;
  });
}
