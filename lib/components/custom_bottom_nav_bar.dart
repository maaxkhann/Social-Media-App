import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/controllers/post_controller.dart';
import 'package:social_media/views/chat/messages_view.dart';
import 'package:social_media/views/home/home_view.dart';
import 'package:social_media/views/notification/notifications_view.dart';
import 'package:social_media/views/post/post_view.dart';
import 'package:social_media/views/profile/profile_view.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final postController = Get.put(PostController(), permanent: true);
  int selectedIndex = 0;
  final List<Widget> screens = [
    HomeView(),
    PostView(),
    NotificationsView(),
    MessagesView(),
    ProfileView(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        onPopInvoked: (didPop) {
          if (!didPop && selectedIndex != 0) {
            setState(() {
              selectedIndex = 0;
            });
          }
        },
        child: Scaffold(
          body: screens.elementAt(selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: onItemTapped,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: AppColors.blue,
            unselectedItemColor: AppColors.black.withValues(alpha: 0.5),

            selectedLabelStyle: TextStyle(
              fontSize: 10,
              color: AppColors.blue,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 10,
              color: AppColors.black.withValues(alpha: 0.5),
              fontWeight: FontWeight.w700,
            ),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.post_add_sharp),
                label: 'Upload',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
