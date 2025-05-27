import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/components/custom_textfield.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/post_controller.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/models/comments_model.dart';

showCommentSheet(
  BuildContext context,
  String postId, {
  String? targetCommentId,
}) {
  final commentController = TextEditingController();
  final postController = Get.find<PostController>();
  final profileController = Get.find<ProfileController>();
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
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: CustomText(
                            title: 'No comments yet.',
                            size: 16,
                          ),
                        );
                      }
                      final scrollController = ScrollController();
                      final Map<String, GlobalKey> commentKeys = {};

                      final comments = snapshot.data;

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
                          return ListView.builder(
                            controller: scrollController,
                            itemCount: comments?.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final comment = comments?[index];
                              final key = GlobalKey();
                              if (comment?.commentId != null) {
                                commentKeys[comment!.commentId] = key;
                              }

                              return Container(
                                key: key,
                                child: Row(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.only(
                                              top: 8,
                                              bottom: 3,
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
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Row(
                                                    children: [
                                                      8.spaceX,
                                                      Flexible(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                CustomText(
                                                                  title:
                                                                      comment
                                                                          ?.user
                                                                          ?.name ??
                                                                      '',
                                                                  size: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                                5.spaceX,
                                                                Obx(() {
                                                                  final isFollowed =
                                                                      profileController
                                                                          .followStatusMap[comment
                                                                              ?.commentBy]
                                                                          ?.value ??
                                                                      false;
                                                                  return profileController
                                                                              .auth
                                                                              .currentUser
                                                                              ?.uid ==
                                                                          comment
                                                                              ?.user
                                                                              ?.userId
                                                                      ? SizedBox.shrink()
                                                                      : InkWell(
                                                                        onTap:
                                                                            () => profileController.follow(
                                                                              !isFollowed,
                                                                              comment!.commentBy,
                                                                            ),
                                                                        child: CustomText(
                                                                          title:
                                                                              isFollowed
                                                                                  ? 'Followed'
                                                                                  : 'Follow',
                                                                          size:
                                                                              8,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          color:
                                                                              AppColors.blue,
                                                                        ),
                                                                      );
                                                                }),
                                                              ],
                                                            ),
                                                            4.spaceY,
                                                            CustomText(
                                                              title:
                                                                  comment
                                                                      ?.user
                                                                      ?.position ??
                                                                  '',
                                                              size: 8,
                                                              color: AppColors
                                                                  .black
                                                                  .withValues(
                                                                    alpha: 0.9,
                                                                  ),
                                                            ),
                                                            8.spaceY,
                                                            CustomText(
                                                              title:
                                                                  comment
                                                                      ?.comment ??
                                                                  '',
                                                              size: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          4.spaceX,
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                            ),
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
                                                    title:
                                                        comment!.isLiked
                                                            ? 'Unlike'
                                                            : 'Like',
                                                    size: 10,
                                                  ),
                                                ),
                                                11.spaceX,
                                                CustomText(
                                                  title: '.',
                                                  size: 10,
                                                  color: AppColors.black
                                                      .withValues(alpha: 0.5),
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
                                                CustomText(
                                                  title: 'Reply',
                                                  size: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomTextField(
                  controller: commentController,
                  fillColor: AppColors.primaryColor,
                  hintColor: AppColors.white,
                  hintText: 'Add comment',
                  suffixIcon: IconButton(
                    onPressed: () {
                      final comment = commentController.text.trim();
                      if (comment.isNotEmpty) {
                        postController.addComment(postId, comment);
                      }
                    },
                    icon: Icon(Icons.send, color: AppColors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
