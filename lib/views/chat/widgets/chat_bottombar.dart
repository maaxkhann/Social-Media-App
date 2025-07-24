import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:social_media/components/custom_textfield.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/controllers/chat_controller.dart';
import 'package:social_media/controllers/profile_controller.dart';
import 'package:uuid/uuid.dart';

class ChatBottomBar extends StatefulWidget {
  final String? otherUserId;
  final String? groupId;
  final bool isGroup;
  const ChatBottomBar({
    super.key,
    this.otherUserId,
    this.groupId,
    this.isGroup = false,
  });

  @override
  State<ChatBottomBar> createState() => _ChatBottomBarState();
}

class _ChatBottomBarState extends State<ChatBottomBar> {
  final chatCont = TextEditingController();
  final chatController = Get.put(ChatController());
  final profileController = Get.find<ProfileController>();

  @override
  void initState() {
    chatCont.clear();
    super.initState();
  }

  final record = AudioRecorder();
  bool isRecording = false;

  Future<void> startRecording() async {
    final hasPermission = await record.hasPermission();
    if (!hasPermission) {
      // Optional: Show a dialog or toast to inform user
      print('Microphone permission denied');
      return;
    }

    try {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/${const Uuid().v4()}.m4a';

      await record.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );

      setState(() => isRecording = true);
    } catch (e) {
      print('Error while starting recording: $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      if (await record.isRecording()) {
        final path = await record.stop();
        setState(() => isRecording = false);

        if (path != null && path.isNotEmpty) {
          final audioFile = File(path);
          if (await audioFile.exists()) {
            await _uploadAndSendVoice(audioFile);
          } else {
            print('Recording file does not exist at path: $path');
          }
        }
      }
    } catch (e) {
      print('Error while stopping recording: $e');
      setState(() => isRecording = false);
    }
  }

  Future<void> _uploadAndSendVoice(File file) async {
    try {
      if (!await file.exists()) {
        debugPrint('Voice file does not exist');
        return;
      }

      String fileName = 'voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      final ref = FirebaseStorage.instance.ref().child(
        'voice_messages/$fileName',
      );

      // Optional: specify contentType
      await ref.putFile(file, SettableMetadata(contentType: 'audio/m4a'));

      String url = await ref.getDownloadURL();
      debugPrint('Voice uploaded: $url');

      if (!widget.isGroup) {
        await chatController.sendMessage(
          currentUserId: chatController.auth.currentUser!.uid,
          otherUserId: widget.otherUserId,
          messageText: '',
          voiceUrl: url,
        );
      } else {
        await chatController.sendGroupMessage(
          groupId: widget.groupId ?? '',
          senderId: chatController.auth.currentUser!.uid,
          senderName: profileController.userModel.value?.name ?? '',
          senderImage: profileController.userModel.value?.image ?? '',
          message: '',
          voiceUrl: url,
        );
      }
    } catch (e) {
      debugPrint('Voice upload error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: chatCont,
              isBorder: false,
              hintText: 'Message...',
              suffixIcon: IconButton(
                onPressed: () {
                  if (chatCont.text.isNotEmpty) {
                    !widget.isGroup
                        ? chatController
                            .sendMessage(
                              currentUserId:
                                  chatController.auth.currentUser!.uid,
                              otherUserId: widget.otherUserId,
                              messageText: chatCont.text,
                            )
                            .then((val) => chatCont.clear())
                        : chatController
                            .sendGroupMessage(
                              groupId: widget.groupId ?? '',
                              senderId: chatController.auth.currentUser!.uid,
                              senderName:
                                  profileController.userModel.value?.name ?? '',
                              senderImage:
                                  profileController.userModel.value?.image ??
                                  '',
                              message: chatCont.text,
                            )
                            .then((value) => chatCont.clear());
                  }
                },
                icon: Icon(Icons.send, color: AppColors.yellow),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  iconSize: 20,
                  visualDensity: VisualDensity.compact,
                  onPressed: () {},
                  icon: Icon(
                    Icons.camera_alt,
                    color: AppColors.black.withValues(alpha: 0.5),
                  ),
                ),
                IconButton(
                  iconSize: 20,
                  visualDensity: VisualDensity.compact,
                  onPressed: isRecording ? stopRecording : startRecording,
                  icon: Icon(
                    isRecording ? Icons.stop : Icons.mic,
                    color:
                        isRecording
                            ? AppColors.red
                            : AppColors.black.withValues(alpha: 0.5),
                  ),
                ),

                IconButton(
                  iconSize: 20,
                  visualDensity: VisualDensity.compact,
                  onPressed: () {},
                  icon: Icon(
                    Icons.attachment_outlined,
                    color: AppColors.black.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
