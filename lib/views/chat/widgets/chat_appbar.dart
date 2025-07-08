import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:social_media/constants/app_colors.dart' show AppColors;
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/extensions/sized_box.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

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
                CircleAvatar(radius: 25),
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
                    title: 'Rubab Shah',
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

  @override
  Size get preferredSize => Size.fromHeight(79);
}
