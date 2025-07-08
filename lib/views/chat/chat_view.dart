import 'package:flutter/material.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/extensions/sized_box.dart';
import 'package:social_media/views/chat/widgets/chat_appbar.dart';
import 'package:social_media/views/chat/widgets/chat_bottombar.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: ChatAppBar(),
        body: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          itemCount: 10,
          separatorBuilder: (context, index) => 18.spaceY,
          itemBuilder:
              (context, index) => Row(
                children: [
                  index.isOdd ? SizedBox.shrink() : CircleAvatar(radius: 18),
                  13.spaceX,
                  Expanded(
                    child: Align(
                      alignment:
                          index.isOdd
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              index.isOdd
                                  ? AppColors.blue
                                  : AppColors.lightShadeGrey.withValues(
                                    alpha: 0.35,
                                  ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 4,
                          children: [
                            CustomText(
                              title: 'Hello, how are you?',
                              size: 11,
                              color:
                                  index.isOdd
                                      ? AppColors.white
                                      : AppColors.black.withValues(alpha: 0.8),
                            ),
                            CustomText(
                              title: '12:31 PM',
                              size: 10,
                              color:
                                  index.isOdd
                                      ? AppColors.white
                                      : AppColors.black.withValues(alpha: 0.8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        ),
        bottomNavigationBar: ChatBottomBar(),
      ),
    );
  }
}
