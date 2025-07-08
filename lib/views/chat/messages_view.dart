import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/views/chat/widgets/message_appbar.dart';
import 'package:social_media/views/chat/widgets/group_widget.dart';
import 'package:social_media/views/chat/widgets/messages_widget.dart';
import 'package:social_media/views/chat/widgets/stories_list.dart';

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
      body: NestedScrollView(
        headerSliverBuilder:
            (context, innerBoxIsScrolled) => [
              SliverAppBar(
                backgroundColor: AppColors.primaryColor,
                pinned: true,
                expandedHeight: 115,
                flexibleSpace: FlexibleSpaceBar(
                  background: MessageAppBar(
                    tabController: tabController,
                    image: profileController.userModel.value?.image,
                  ),
                ),
              ),
            ],
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
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Obx(() {
                          return CircleAvatar(
                            radius: 25,
                            foregroundImage: NetworkImage(
                              profileController.userModel.value?.image ??
                                  'https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1631&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                            ),
                          );
                        }),
                        12.spaceX,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5,
                          children: [
                            CustomText(title: 'My Story', size: 15),
                            CustomText(title: 'Today at 4:16 PM', size: 10),
                          ],
                        ),
                        Spacer(),
                        Column(
                          spacing: 6,
                          children: [
                            Icon(
                              Icons.visibility,
                              size: 15,
                              color: AppColors.black.withValues(alpha: 0.5),
                            ),
                            CustomText(
                              title: '26 Views',
                              size: 10,
                              color: AppColors.black.withValues(alpha: 05),
                            ),
                          ],
                        ),
                      ],
                    ),
                    10.spaceY,
                    Divider(
                      thickness: 4,
                      color: AppColors.lightGrey.withValues(alpha: 0.5),
                    ),
                    14.spaceY,
                    CustomText(title: 'Other’s Stories', size: 15),
                    19.spaceY,
                    ListView.separated(
                      itemCount: 10,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => 18.spaceY,
                      itemBuilder: (context, index) {
                        return StoriesList();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // appBar: AppBar(
      //   backgroundColor: AppColors.primaryColor,
      //   toolbarHeight: 135,
      //   flexibleSpace: Padding(
      //     padding: const EdgeInsets.only(left: 20),
      //     child: ChatAppBar(
      //       tabController: tabController,
      //       image: profileController.userModel.value?.image,
      //     ),
      //   ),
      // ),
      // body: Padding(
      //   padding: EdgeInsets.only(top: 20, left: 15, right: 8, bottom: 15),
      //   child: TabBarView(
      //     controller: tabController,
      //     children: [
      //       ListView.separated(
      //         itemCount: 10,
      //         separatorBuilder: (context, index) => 18.spaceY,
      //         itemBuilder: (context, index) {
      //           return MessagesWidget();
      //         },
      //       ),
      //       ListView.separated(
      //         itemCount: 10,
      //         separatorBuilder: (context, index) => 18.spaceY,
      //         itemBuilder: (context, index) {
      //           return GroupWidget();
      //         },
      //       ),
      //       SingleChildScrollView(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Row(
      //               children: [
      //                 CircleAvatar(
      //                   radius: 25,
      //                   foregroundImage: NetworkImage(
      //                     'https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1631&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      //                   ),
      //                 ),
      //                 12.spaceX,
      //                 Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   spacing: 5,
      //                   children: [
      //                     CustomText(title: 'My Story', size: 15),
      //                     CustomText(title: 'Today at 4:16 PM', size: 10),
      //                   ],
      //                 ),
      //                 Spacer(),
      //                 Column(
      //                   spacing: 6,
      //                   children: [
      //                     Icon(
      //                       Icons.visibility,
      //                       size: 15,
      //                       color: AppColors.black.withValues(alpha: 0.5),
      //                     ),
      //                     CustomText(
      //                       title: '26 Views',
      //                       size: 10,
      //                       color: AppColors.black.withValues(alpha: 05),
      //                     ),
      //                   ],
      //                 ),
      //               ],
      //             ),
      //             10.spaceY,
      //             Divider(
      //               thickness: 4,
      //               color: AppColors.lightGrey.withValues(alpha: 0.5),
      //             ),
      //             14.spaceY,
      //             CustomText(title: 'Other’s Stories', size: 15),
      //             19.spaceY,
      //             ListView.separated(
      //               itemCount: 10,
      //               shrinkWrap: true,
      //               physics: NeverScrollableScrollPhysics(),
      //               separatorBuilder: (context, index) => 18.spaceY,
      //               itemBuilder: (context, index) {
      //                 return StoriesList();
      //               },
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
