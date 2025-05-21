import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/components/custom_appbar.dart';
import 'package:social_media/controllers/post_controller.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/shared/console.dart';
import 'package:social_media/views/home/widgets/comment_dialog.dart';
import 'package:social_media/views/home/widgets/icons_widget.dart';
import 'package:social_media/views/post/widgets/post_actions.dart';
import 'package:video_player/video_player.dart';

class FullPostScreen extends StatefulWidget {
  const FullPostScreen({super.key});

  @override
  State<FullPostScreen> createState() => _FullPostScreenState();
}

class _FullPostScreenState extends State<FullPostScreen> {
  final postController = Get.find<PostController>();
  PostModel? post;
  VideoPlayerController? videoController;

  @override
  void initState() {
    super.initState();
    post = Get.arguments['post'] as PostModel;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments['commentId'] != null) {
        showCommentSheet(
          context,
          post?.postId ?? '',
          targetCommentId: Get.arguments['commentId'],
        );
      }
    });

    if (post?.postType == 'video') {
      // ignore: deprecated_member_use
      videoController = VideoPlayerController.network(post?.mediaUrl ?? '')
        ..initialize().then((_) {
          setState(() {});
          videoController?.play();
        });
    }
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  child: CustomAppBar(),
                ),
                SizedBox(height: Get.height * 0.2),
                post?.postType == 'image'
                    ? AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Image.network(
                        post?.mediaUrl ?? '',
                        fit: BoxFit.fill,
                      ),
                    )
                    : videoController?.value.isInitialized == true
                    ? AspectRatio(
                      aspectRatio: 1 / 1,
                      child: VideoPlayer(videoController!),
                    )
                    : const Center(child: CircularProgressIndicator()),
              ],
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: PostActions(post: post),
            ),
          ],
        ),
      ),
    );
  }
}
