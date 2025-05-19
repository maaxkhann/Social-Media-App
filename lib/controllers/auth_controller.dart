import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:social_media/components/custom_bottom_nav_bar.dart';
import 'package:social_media/routes/app_routes.dart';
import 'package:social_media/shared/console.dart';
import 'package:social_media/views/auth/login_view.dart';
import 'package:social_media/views/home/home_view.dart';

class AuthController extends GetxController {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxString image = ''.obs;

  Future<void> createUser(
    String image,
    String name,
    String password,
    String email,
    String phoneNumber,
    String position,
  ) async {
    final file = File(image);
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final Reference ref = storage.ref().child("Profile_images/$fileName");
    final UploadTask uploadTask = ref.putFile(file);
    final TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        String uId = auth.currentUser!.uid;

        DocumentReference documentReference = firestore
            .collection('Users')
            .doc(uId);
        await documentReference.set({
          'image': downloadUrl,
          'name': name,
          'email': email,
          'position': position,
          'phone': phoneNumber,
          'isFollowed': false,
          'userId': uId,
        });

        Get.offNamed(AppRoutes.loginView);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return;
      } else if (e.code == 'weak-password') {
        return;
      } else if (e.code == 'wrong-password') {
      } else if (e.code == 'invalid-email') {
      } else if (e.code == 'user-not-found') {}
    } catch (e) {}
  }

  Future<void> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      console('responseeeeeee ${userCredential.credential}');
      console('responseeeeeee ${userCredential.user?.email}');
      if (userCredential.user != null) {
        Get.offNamed(AppRoutes.customBottomNavBar);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return;
      } else if (e.code == 'weak-password') {
        return;
      } else if (e.code == 'wrong-password') {
      } else if (e.code == 'invalid-email') {
      } else if (e.code == 'user-not-found') {}
    } catch (e) {
      console('responseeeeeee ${e.toString()}');
    }
  }
}
