import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/app_colors.dart' show AppColors;
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:social_media/extensions/sized_box.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? otherUserId;
  const ChatAppBar({super.key, this.otherUserId});

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(79);
}

class _ChatAppBarState extends State<ChatAppBar> {
  final profileController = Get.put(ProfileController());

  @override
  void initState() {
    profileController.getUserData(otherId: widget.otherUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.09),
              offset: Offset(0, 2),
              blurRadius: 6.3,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                margin: EdgeInsets.only(bottom: 5),

                width: 18,
                height: 15,
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.black.withValues(alpha: 0.2),
                ),
              ),
            ),
            10.spaceX,
            Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  foregroundImage: NetworkImage(
                    profileController.userModel.value?.image ??
                        'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?semt=ais_hybrid&w=740',
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 4,
                  child: CircleAvatar(
                    radius: 6.5,
                    backgroundColor: AppColors.yellow,
                  ),
                ),
              ],
            ),
            15.spaceX,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    title: profileController.userModel.value?.name ?? '',
                    size: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  4.spaceY,
                  CustomText(
                    title: 'Active now',
                    size: 10,

                    color: AppColors.black.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
            Spacer(),
            IconButton(
              visualDensity: VisualDensity.comfortable,
              onPressed: () {},
              iconSize: 18,
              color: AppColors.black.withValues(alpha: 0.5),
              icon: Icon(Icons.call),
            ),

            IconButton(
              color: AppColors.black.withValues(alpha: 0.5),
              visualDensity: VisualDensity.compact,
              onPressed: () {},
              icon: Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }
}
