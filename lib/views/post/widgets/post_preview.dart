import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/routes/app_routes.dart';
import 'package:social_media/utilities/thumbnail.dart';
import 'package:video_player/video_player.dart';

class PostPreview extends StatefulWidget {
  final PostModel post;
  const PostPreview({super.key, required this.post});

  @override
  State<PostPreview> createState() => _PostPreviewState();
}

class _PostPreviewState extends State<PostPreview> {
  VideoPlayerController? videoController;
  bool isInitialized = false;
  bool hasError = false;
  String? thumbnailPath;

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  void initializeVideo() {
    videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.post.mediaUrl ?? ''),
      )
      ..initialize()
          .then((_) {
            setState(() {
              isInitialized = true;
              hasError = false;
            });
          })
          .catchError((error) {
            setState(() {
              hasError = true;
            });
          });
    getThumbnail();
  }

  getThumbnail() async {
    try {
      String? thumbnail = await Thumbnail.ins.generateThumbnail(
        widget.post.mediaUrl ?? '',
      );
      if (!mounted) return;
      setState(() {
        thumbnailPath = thumbnail;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        hasError = true;
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
    return GestureDetector(
      onTap:
          () => Get.toNamed(
            AppRoutes.fullPostScreen,
            arguments: {'post': widget.post},
          ),
      child: Container(
        width: double.infinity,
        height: 152,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image:
              widget.post.postType == 'image'
                  ? DecorationImage(
                    image: NetworkImage(widget.post.mediaUrl ?? ''),
                    fit: BoxFit.cover,
                  )
                  : null,
          color: widget.post.postType == 'video' ? Colors.black : null,
        ),
        child:
            widget.post.postType == 'video'
                ? Stack(
                  fit: StackFit.expand,
                  children: [
                    if (thumbnailPath != null)
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.file(
                          File(thumbnailPath!),
                          fit: BoxFit.cover,
                        ),
                      )
                    else if (hasError)
                      const Center(
                        child: Icon(Icons.error, color: Colors.red, size: 50),
                      ),

                    if (!hasError)
                      const Center(
                        child: Icon(
                          Icons.play_circle,
                          color: Colors.white,
                          size: 40,
                        ),
                      )
                    else
                      const Center(child: CircularProgressIndicator()),
                  ],
                )
                : null,
      ),
    );
  }
}
