import 'package:flutter/material.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/extensions/sized_box.dart';

class ChatAppBar extends StatelessWidget {
  final String? image;
  const ChatAppBar({super.key, required this.tabController, this.image});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        20.spaceY,
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: CircleAvatar(
                radius: 25,
                foregroundImage: NetworkImage(
                  image ??
                      'https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1631&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                ),
              ),
            ),
          ],
        ),
        Spacer(),
        TabBar(
          controller: tabController,
          labelStyle: TextStyle(
            fontSize: 14,
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: TextStyle(fontSize: 14, color: AppColors.white),
          dividerHeight: 0,
          indicatorColor: AppColors.yellow,
          labelPadding: EdgeInsets.only(bottom: 8),
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 3.0, color: AppColors.yellow),
            borderRadius: BorderRadius.circular(12),
            insets: EdgeInsets.symmetric(
              horizontal: -8,
            ), // <-- wider than label
          ),
          tabs: [Text('Chats'), Text('Groups'), Text('Stories')],
        ),
      ],
    );
  }
}
