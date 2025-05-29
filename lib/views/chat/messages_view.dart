import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/views/chat/widgets/chat_appbar.dart';
import 'package:social_media/views/chat/widgets/group_widget.dart';
import 'package:social_media/views/chat/widgets/messages_widget.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView>
    with SingleTickerProviderStateMixin {
  final profileController = Get.find<ProfileController>();
  late TabController tabController;
  @override
  void initState() {
    profileController.getUserData();
    tabController = TabController(length: 3, vsync: this);
    // tabController.addListener(() {
    //   setState(() {});
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        toolbarHeight: 135,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: ChatAppBar(
            tabController: tabController,
            image: profileController.userModel.value?.image,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20, left: 15, right: 8, bottom: 15),
        child: TabBarView(
          controller: tabController,
          children: [
            ListView.separated(
              itemCount: 10,
              separatorBuilder: (context, index) => 18.spaceY,
              itemBuilder: (context, index) {
                return MessagesWidget();
              },
            ),
            ListView.separated(
              itemCount: 10,
              separatorBuilder: (context, index) => 18.spaceY,
              itemBuilder: (context, index) {
                return GroupWidget();
              },
            ),
            Center(child: CustomText(title: 'Stories')),
          ],
        ),
      ),
    );
  }
}
