import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/post_controller.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/views/post/widgets/post_actions.dart';
import 'package:social_media/views/post/widgets/post_preview.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomePostsWidget extends StatefulWidget {
  const HomePostsWidget({super.key, required this.post});

  final PostModel post;

  @override
  State<HomePostsWidget> createState() => _HomePostsWidgetState();
}

class _HomePostsWidgetState extends State<HomePostsWidget> {
  final postController = Get.find<PostController>();
  final profileController = Get.find<ProfileController>();
  final commentController = TextEditingController();
  bool isFollowed = false;
  bool isFullText = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => followStatus());
    super.initState();
  }

  followStatus() async {
    profileController.loadFollowStatus(widget.post.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    widget.post.user?.image ??
                        'https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1631&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  ),
                ),
                12.spaceX,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title: widget.post.user?.name ?? '',
                          fontWeight: FontWeight.w700,
                        ),
                        5.spaceY,
                        CustomText(
                          title: widget.post.user?.position ?? '',
                          size: 10,
                        ),
                      ],
                    ),
                    5.spaceY,
                    CustomText(
                      title: timeago.format(widget.post.timestamp.toDate()),
                      size: 10,
                    ),
                  ],
                ),
              ],
            ),
            widget.post.user?.userId == postController.auth.currentUser?.uid
                ? SizedBox()
                : Obx(() {
                  final isFollowed =
                      profileController
                          .followStatusMap[widget.post.userId]
                          ?.value ??
                      false;
                  return InkWell(
                    onTap:
                        () => profileController.follow(
                          !isFollowed,
                          widget.post.userId,
                        ),
                    child: Row(
                      children: [
                        Icon(Icons.add, color: AppColors.blue, size: 10),
                        4.spaceX,
                        CustomText(
                          title: isFollowed ? 'Unfollow' : 'Follow',
                          fontWeight: FontWeight.w800,
                          size: 12,
                          color: AppColors.blue,
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
        17.spaceY,
        widget.post.mediaUrl == null || widget.post.mediaUrl!.isEmpty
            ? Center(
              child: ExpandableText(
                text: widget.post.text,
                trimLines: 4,
                fontSize: 16,
              ),
            )
            : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpandableText(
                  text: widget.post.text,
                  trimLines: 3,
                  fontSize: 11,
                ),
                16.spaceY,
                //  if (post.image.isNotEmpty)
                PostPreview(post: widget.post),
              ],
            ),

        7.spaceY,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.thumb_up,
                      color: AppColors.blue,
                      size: 13,
                    ),
                  ),
                  7.7.spaceX,
                  Obx(() {
                    return CustomText(
                      title:
                          postController.likesCounts[widget.post.postId]
                              .toString(),
                      size: 10,
                    );
                  }),
                ],
              ),

              Obx(() {
                return CustomText(
                  title:
                      '${postController.commentsCounts[widget.post.postId]}  Comments',
                  size: 10,
                );
              }),
            ],
          ),
        ),
        Divider(color: AppColors.black.withValues(alpha: 0.18)),
        8.spaceY,
        PostActions(post: widget.post),
      ],
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;
  final double fontSize;

  const ExpandableText({
    super.key,
    required this.text,
    this.trimLines = 3,
    this.fontSize = 14,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;
  bool showToggle = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  void _checkOverflow() {
    final span = TextSpan(
      text: widget.text,
      style: TextStyle(fontSize: widget.fontSize),
    );
    final tp = TextPainter(
      text: span,
      maxLines: widget.trimLines,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: MediaQuery.of(context).size.width * 0.85);
    setState(() {
      showToggle = tp.didExceedMaxLines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: widget.text,
          size: widget.fontSize,
          maxLine: isExpanded ? 50 : widget.trimLines,
          txtOverFlow:
              isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        if (showToggle)
          TextButton(
            onPressed: () => setState(() => isExpanded = !isExpanded),
            child: CustomText(
              title: isExpanded ? 'See Less' : 'See More',
              size: 10,
            ),
          ),
      ],
    );
  }
}
