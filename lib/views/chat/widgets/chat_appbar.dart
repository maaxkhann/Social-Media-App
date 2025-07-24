import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/app_colors.dart' show AppColors;
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:social_media/extensions/sized_box.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? otherUserId;
  final bool isGroup;
  final String? groupId;
  final String? groupName;

  const ChatAppBar({
    super.key,
    this.otherUserId,
    this.groupId,
    this.groupName,
    this.isGroup = false,
  });

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(79);
}

class _ChatAppBarState extends State<ChatAppBar> {
  final profileController = Get.find<ProfileController>();
  String name = '';
  String imageUrl = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();

    if (widget.isGroup && widget.groupId != null) {
      FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .get()
          .then((doc) {
            setState(() {
              name = doc['name'] ?? '';
              imageUrl =
                  "https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=random";
              loading = false;
            });
          });
    } else if (widget.otherUserId != null) {
      profileController.getUserData(otherId: widget.otherUserId);
      setState(() {
        name = profileController.userModel.value?.name ?? '';
        imageUrl =
            profileController.userModel.value?.image ??
            'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg';
        loading = false;
      });
    }
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
              color: AppColors.black.withAlpha(25),
              offset: Offset(0, 2),
              blurRadius: 6.3,
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 18,
                height: 15,
                margin: EdgeInsets.only(bottom: 5),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.black.withAlpha(100),
                ),
              ),
            ),
            10.spaceX,
            CircleAvatar(radius: 25, backgroundImage: NetworkImage(imageUrl)),
            15.spaceX,
            // loading
            //     ? CircularProgressIndicator()
            //     :
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    title: name,
                    size: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  // 4.spaceY,
                  // CustomText(
                  //   title: widget.isGroup ? '' : 'Active now',
                  //   size: 10,
                  //   color: AppColors.black.withAlpha(120),
                  // ),
                ],
              ),
            ),
            if (!widget.isGroup) ...[
              IconButton(
                visualDensity: VisualDensity.comfortable,
                icon: Icon(Icons.call),
                iconSize: 18,
                color: AppColors.black.withAlpha(120),
                onPressed: () {},
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(Icons.more_vert),
                color: AppColors.black.withAlpha(120),
                onPressed: () {},
              ),
            ],
          ],
        ),
      ),
    );
  }
}
