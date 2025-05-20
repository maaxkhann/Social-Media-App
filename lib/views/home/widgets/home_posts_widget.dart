import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/post_controller.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/views/home/widgets/comment_dialog.dart';
import 'package:social_media/views/home/widgets/icons_widget.dart';
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
  bool? isFollowed = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => followStatus());
    super.initState();
  }

  followStatus() async {
    isFollowed = await profileController.getFollowStatus(widget.post.userId);
    setState(() {});
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
            InkWell(
              onTap: () {
                profileController
                    .follow(!isFollowed!, widget.post.userId)
                    .then((val) => followStatus());
              },
              child: Row(
                spacing: 4,
                children: [
                  Icon(Icons.add, color: AppColors.blue, size: 10),
                  CustomText(
                    title: isFollowed! ? 'Unfollow' : 'Follow',
                    fontWeight: FontWeight.w800,
                    size: 12,
                    color: AppColors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
        17.spaceY,
        CustomText(title: widget.post.text, size: 10),
        16.spaceY,
        //  if (post.image.isNotEmpty)
        Container(
          width: double.infinity,
          height: 152,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(widget.post.image),
              fit: BoxFit.cover,
            ),
          ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconsWidget(
              onTap:
                  () => postController.likePost(
                    widget.post.userId,
                    widget.post.postId,
                    !widget.post.isLiked,
                  ),
              title: 'Like',
              isLiked: widget.post.isLiked,
              icon:
                  widget.post.isLiked
                      ? Icons.thumb_up
                      : Icons.thumb_up_alt_outlined,
            ),
            IconsWidget(
              onTap: () => showCommentSheet(context, widget.post.postId),
              title: 'Comment',
              icon: Icons.comment,
            ),
            IconsWidget(title: 'Share', icon: Icons.upload),
            IconsWidget(title: 'Message', icon: Icons.message),
          ],
        ),
      ],
    );
  }

  //   void _showCommentDialog(BuildContext context) {
  //     final TextEditingController commentController = TextEditingController();

  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           title: const Text('Add Comment'),
  //           content: TextField(
  //             controller: commentController,
  //             maxLines: 3,
  //             decoration: const InputDecoration(
  //               hintText: 'Type your comment here...',
  //               border: OutlineInputBorder(),
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.of(context).pop(),
  //               child: const Text('Cancel'),
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 final comment = commentController.text.trim();
  //                 if (comment.isNotEmpty) {
  //                   // TODO: Save comment logic
  //                   console('Commented: $comment');
  //                   Navigator.of(context).pop();
  //                 }
  //               },
  //               child: const Text('Submit'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }
}
