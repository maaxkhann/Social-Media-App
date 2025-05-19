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

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final postController = Get.find<PostController>();
  final profileController = Get.find<ProfileController>();
  final postCont = TextEditingController();
  String? image;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              40.spaceY,
              Obx(() {
                return CircleAvatar(
                  radius: 25,
                  foregroundImage: NetworkImage(
                    profileController.userModel.value?.image ??
                        'https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1631&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  ),
                );
              }),
              18.spaceY,
              CustomText(title: 'Success Stories', size: 11),
              11.spaceY,
              StoriesWidget(),
              5.spaceY,

              CustomTextField(
                controller: postCont,
                isBorder: false,
                hintText: 'Share your story or idea...',
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () async {
                    String? pickedImage = await Pickers.ins.pickImage();
                    console(pickedImage);
                    if (pickedImage != null) {
                      image = pickedImage;
                      setState(() {});
                    }
                  },
                  icon: Icon(
                    Icons.image,
                    color: AppColors.black.withValues(alpha: 0.5),
                  ),
                ),
                if (image != null)
                  Image.file(
                    width: 50,
                    height: 50,
                    fit: BoxFit.scaleDown,
                    File(image!),
                  ),
                IconButton(
                  onPressed:
                      () =>
                          postController.createPost(image ?? '', postCont.text),
                  icon: Icon(
                    Icons.send,
                    color: AppColors.black.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
