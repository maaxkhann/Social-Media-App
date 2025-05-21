import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/components/custom_appbar.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/views/home/widgets/comment_dialog.dart';
import 'package:video_player/video_player.dart';

class FullPostScreen extends StatefulWidget {
  const FullPostScreen({super.key});

  @override
  State<FullPostScreen> createState() => _FullPostScreenState();
}

class _FullPostScreenState extends State<FullPostScreen> {
  PostModel? post;
  VideoPlayerController? videoController;

  @override
  void initState() {
    super.initState();
    post = Get.arguments['post'] as PostModel;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments['focusComment'] || !Get.arguments['focusComment']) {
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: CustomAppBar(),
            ),
            SizedBox(height: Get.height * 0.2),
            post?.postType == 'image'
                ? AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image.network(post?.mediaUrl ?? '', fit: BoxFit.cover),
                )
                : videoController?.value.isInitialized == true
                ? AspectRatio(
                  aspectRatio: 1 / 1,
                  child: VideoPlayer(videoController!),
                )
                : const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
