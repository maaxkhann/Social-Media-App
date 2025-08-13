import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/components/stories_widget.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/post_controller.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/services/notification_service.dart';
import 'package:social_media/views/home/widgets/home_posts_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final scrollController = ScrollController();
  final postController = Get.find<PostController>();
  final profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    upadateToken();
    scrollController.addListener(_onScroll);
  }

  upadateToken() async {
    await NotificationServices().saveDeviceTokenToFirestore();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !postController.isLoadingMorePosts.value &&
        postController.hasMore) {
      postController.fetchMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final posts = postController.posts;
        if (postController.isPostsLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            // Header avatar
            Align(
              alignment: Alignment.topLeft,
              child: Obx(() {
                return CircleAvatar(
                  radius: 25,
                  foregroundImage: NetworkImage(
                    profileController.userModel.value?.image ??
                        'https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1631&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  ),
                );
              }),
            ),
            18.spaceY,

            // Stories
            CustomText(title: 'Success Stories', size: 11),
            11.spaceY,
            StoriesWidget(),
            13.spaceY,

            // Posts List
            ...posts.map(
              (post) =>
                  Column(children: [HomePostsWidget(post: post), 10.spaceY]),
            ),

            // Loader
            if (postController.isLoadingMorePosts.value)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      }),
    );
  }
}
