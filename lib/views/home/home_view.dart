import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/components/stories_widget.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/post_controller.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/views/home/widgets/home_posts_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final postController = Get.find<PostController>();
    final profileController = Get.find<ProfileController>();
    return Scaffold(
      body: SingleChildScrollView(
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
            // CustomTextField(hintText: 'Write something'),
            13.spaceY,
            StreamBuilder<List<PostModel>>(
              stream: postController.getPostsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: CustomText(title: 'No posts available', size: 16),
                  );
                }

                final posts = snapshot.data!;

                return ListView.separated(
                  itemCount: posts.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder:
                      (_, __) => Container(
                        margin: EdgeInsets.symmetric(vertical: 11),
                        height: 7,
                        decoration: BoxDecoration(color: AppColors.lightGrey),
                      ),

                  itemBuilder: (context, index) {
                    final post = posts[index];
                    // final user = post.user;

                    return HomePostsWidget(post: post);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
