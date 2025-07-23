import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:social_media/extensions/sized_box.dart';

class GroupMemberSelector extends StatefulWidget {
  const GroupMemberSelector({super.key});

  @override
  State<GroupMemberSelector> createState() => _GroupMemberSelectorState();
}

class _GroupMemberSelectorState extends State<GroupMemberSelector> {
  final profileController = Get.find<ProfileController>();
  final RxSet<String> selectedUserIds = <String>{}.obs;

  @override
  void initState() {
    super.initState();
    profileController.fetchAllOtherUsers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Obx(() {
            if (selectedUserIds.isEmpty) return SizedBox();
            return Container(
              height: 70,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children:
                    selectedUserIds.map((id) {
                      final user = profileController.allUsers.firstWhereOrNull(
                        (u) => u.userId == id,
                      );
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(user?.image ?? ''),
                            ),
                            4.spaceY,
                            Text(
                              user?.name.split(' ').first ?? '',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            );
          }),
          Expanded(
            child: Obx(() {
              final users = profileController.allUsers;
              if (users.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.separated(
                itemCount: users.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final user = users[index];
                  final isSelected = selectedUserIds.contains(user.userId);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.image),
                    ),
                    title: Text(user.name),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        toggleSelection(user.userId);
                        setState(() {});
                      },
                    ),
                    onTap: () {
                      toggleSelection(user.userId);
                      setState(() {});
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void toggleSelection(String userId) {
    selectedUserIds.contains(userId)
        ? selectedUserIds.remove(userId)
        : selectedUserIds.add(userId);
  }
}
