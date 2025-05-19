import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/components/custom_textfield.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/post_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/models/comments_model.dart';

showCommentSheet(BuildContext context, String postId) {
  final commentController = TextEditingController();
  final postController = Get.find<PostController>();
  final commentStream = postController.getComments(postId);
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 30,
          left: 12,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              12.spaceY,
              CustomText(
                title: 'Comments',
                size: 10,
                fontWeight: FontWeight.w700,
              ),
              19.spaceY,
              StreamBuilder<List<CommentsModel>>(
                stream: commentStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: CustomText(title: 'No comments yet.', size: 16),
                    );
                  }

                  final comments = snapshot.data;
                  return ListView.builder(
                    itemCount: comments?.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final comment = comments?[index];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: CircleAvatar(
                              radius: 24,
                              foregroundImage: NetworkImage(
                                comment?.user?.image ?? '',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                    bottom: 4,
                                    left: 9,
                                    right: 25,
                                  ),
                                  padding: EdgeInsets.only(
                                    left: 13,
                                    right: 13,
                                    top: 7,
                                    bottom: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          8.spaceX,
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CustomText(
                                                    title:
                                                        comment?.user?.name ??
                                                        '',
                                                    size: 10,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  5.spaceX,
                                                  CustomText(
                                                    title: 'Follow',
                                                    size: 8,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.blue,
                                                  ),
                                                ],
                                              ),
                                              4.spaceY,
                                              CustomText(
                                                title:
                                                    comment?.user?.position ??
                                                    '',
                                                size: 8,
                                                color: AppColors.black
                                                    .withValues(alpha: 0.9),
                                              ),
                                              8.spaceY,
                                              CustomText(
                                                title: comment?.comment ?? '',
                                                size: 10,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                4.spaceX,
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      CustomText(title: 'Like', size: 10),
                                      11.spaceX,
                                      CustomText(
                                        title: '.',
                                        size: 10,
                                        color: AppColors.black.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                      11.spaceX,
                                      Icon(
                                        Icons.thumb_up_outlined,
                                        color: AppColors.blue,
                                        size: 9,
                                      ),
                                      3.spaceX,
                                      CustomText(title: '3', size: 10),
                                      12.spaceX,
                                      CustomText(title: 'Reply', size: 10),
                                    ],
                                  ),
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

              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: CustomTextField(
                  controller: commentController,
                  hintText: 'Add comment',
                  suffixIcon: IconButton(
                    onPressed: () {
                      final comment = commentController.text.trim();
                      if (comment.isNotEmpty) {
                        postController.addComment(postId, comment);
                      }
                    },
                    icon: Icon(Icons.send, color: AppColors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class CustomButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        side:
            borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      onPressed: onTap,
      child: CustomText(title: title, size: 16, color: textColor),
    );
  }
}
