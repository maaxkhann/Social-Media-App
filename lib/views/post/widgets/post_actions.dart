import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/controllers/post_controller.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/routes/app_routes.dart';
import 'package:social_media/views/home/widgets/comment_dialog.dart';
import 'package:social_media/views/home/widgets/icons_widget.dart';

class PostActions extends StatefulWidget {
  const PostActions({super.key, required this.post});

  final PostModel? post;

  @override
  State<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  final postController = Get.find<PostController>();
  final profileController = Get.find<ProfileController>();
  PostModel? livePost;

  @override
  void initState() {
    super.initState();

    livePost = widget.post;
    postController
        .getPost(widget.post?.postId ?? '')
        .listen(
          (updatedPost) => setState(() {
            livePost = updatedPost;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconsWidget(
          onTap:
              () => postController.likePost(
                livePost!.userId,
                livePost!.postId,
                !livePost!.isLiked,
              ),
          title: 'Like',
          isLiked: livePost!.isLiked,
          icon:
              livePost!.isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
        ),
        IconsWidget(
          onTap: () => showCommentSheet(context, livePost!.postId),
          title: 'Comment',
          icon: Icons.comment,
        ),
        IconsWidget(title: 'Share', icon: Icons.upload),
        IconsWidget(
          title: 'Message',
          icon: Icons.message,
          onTap: () => Get.toNamed(AppRoutes.chatView),
        ),
      ],
    );
  }
}
