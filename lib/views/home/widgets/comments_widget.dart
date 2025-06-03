import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/post_controller.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/models/comments_model.dart';
import 'package:social_media/views/home/widgets/comment_reply_widget.dart'
    show CommentReplyWidget;

class CommentsWidget extends StatefulWidget {
  const CommentsWidget({
    super.key,
    required this.scrollController,
    required this.comments,
    required this.commentKeys,
  });

  final ScrollController scrollController;
  final List<CommentsModel>? comments;
  final Map<String, GlobalKey<State<StatefulWidget>>> commentKeys;

  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  final profileController = Get.find<ProfileController>();
  final postController = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      itemCount: (widget.comments?.length ?? 0) + 1,
      shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        //   final comment = widget.comments?[index];
        final comments = widget.comments ?? [];
        final key = GlobalKey();

        // 👇 Check loader condition FIRST
        if (index == comments.length) {
          return Obx(
            () =>
                postController.isMoreCommentsLoading.value
                    ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: CircularProgressIndicator()),
                    )
                    : const SizedBox.shrink(),
          );
        }
        final comment = comments[index];
        // if (comment.commentId != null) {
        widget.commentKeys[comment.commentId] = key;
        // }

        return Container(
          key: key,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: CircleAvatar(
                  radius: 24,
                  foregroundImage: NetworkImage(comment.user?.image ?? ''),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        left: 12,
                        right: 12,
                        top: 7,
                        bottom: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(2),
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
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CustomText(
                                            title: comment.user?.name ?? '',
                                            size: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          5.spaceX,
                                          Obx(() {
                                            final isFollowed =
                                                profileController
                                                    .followStatusMap[comment
                                                        .commentBy]
                                                    ?.value ??
                                                false;
                                            return profileController
                                                        .auth
                                                        .currentUser
                                                        ?.uid ==
                                                    comment.user?.userId
                                                ? SizedBox.shrink()
                                                : InkWell(
                                                  onTap:
                                                      () => profileController
                                                          .follow(
                                                            !isFollowed,
                                                            comment.commentBy,
                                                          ),
                                                  child: CustomText(
                                                    title:
                                                        isFollowed
                                                            ? 'Followed'
                                                            : 'Follow',
                                                    size: 8,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.blue,
                                                  ),
                                                );
                                          }),
                                        ],
                                      ),
                                      4.spaceY,
                                      CustomText(
                                        title: comment.user?.position ?? '',
                                        size: 8,
                                        color: AppColors.black.withValues(
                                          alpha: 0.9,
                                        ),
                                      ),
                                      6.spaceY,
                                      CustomText(
                                        title: comment.comment,
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
                    CommentReplyWidget(
                      comment: comment,
                      isFocus: (p0) {
                        postController.setAutoFocus(p0);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
