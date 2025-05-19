import 'package:flutter/material.dart';
import 'package:social_media/constants/app_colors.dart';

class StoriesWidget extends StatelessWidget {
  const StoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          10,
          (index) => Padding(
            //  padding: EdgeInsets.only(right: index == itemCount - 1 ? 0 : 14),
            padding: EdgeInsets.only(right: index == 9 ? 0 : 14),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.yellow,
              child: CircleAvatar(radius: 25),
            ),
          ),
        ),
      ),
    );
  }
}
