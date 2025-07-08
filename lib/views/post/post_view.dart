import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/components/custom_textfield.dart';
import 'package:social_media/components/stories_widget.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/post_controller.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/shared/console.dart';
import 'package:social_media/shared/utilities/pickers.dart';
import 'package:social_media/utilities/thumbnail.dart';
import 'package:social_media/views/post/widgets/media_picker_sheet.dart';

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final postController = Get.find<PostController>();
  final profileController = Get.find<ProfileController>();
  final postCont = TextEditingController();
  String? filePath;
  String? postType;
  String? thumbnailPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      40.spaceY,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              return CircleAvatar(
                                radius: 25,
                                foregroundImage: NetworkImage(
                                  profileController.userModel.value?.image ??
                                      'https://images.unsplash.com/photo-1511367461989-f85a21fda167',
                                ),
                              );
                            }),
                            18.spaceY,
                            CustomTextField(
                              controller: postCont,
                              isBorder: false,
                              hintText: 'Share your story or idea...',
                              maxLines: 4,
                            ),
                          ],
                        ),
                      ),
                      12.spaceY,
                      if (filePath != null)
                        postType == 'image'
                            ? Image.file(
                              File(filePath!),
                              width: double.infinity,
                              height: Get.height * 0.42,
                              fit: BoxFit.fill,
                            )
                            : thumbnailPath != null
                            ? Image.file(
                              File(thumbnailPath!),
                              width: double.infinity,
                              height: Get.height * 0.42,
                              fit: BoxFit.fill,
                            )
                            : Center(child: Icon(Icons.video_file, size: 40)),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () async {
                                MediaPickerSheet.show(
                                  context: context,
                                  onPicked: (path, type) async {
                                    String? thumb;
                                    if (type == 'video') {
                                      thumb = await Thumbnail.ins
                                          .generateThumbnail(path);
                                    }
                                    setState(() {
                                      filePath = path;
                                      postType = type;
                                      thumbnailPath = thumb;
                                    });
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.image,
                                color: AppColors.black.withValues(alpha: 0.5),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (postCont.text.isEmpty && filePath == null) {
                                  Get.snackbar(
                                    'Error',
                                    'Please add a post content or media.',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  return;
                                }
                                postController.createPost(
                                  filePath ?? '',
                                  postCont.text,
                                  postType ?? '',
                                );
                              },
                              icon: Icon(
                                Icons.send,
                                color: AppColors.black.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
