import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:social_media/general/validation.dart';
import 'package:social_media/routes/app_routes.dart';
import 'package:social_media/shared/console.dart';
import 'package:social_media/utilities/pops.dart';

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
    String confirmPassword,
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
      bool isValidate = validateRegister(
        image,
        name,
        email,
        phoneNumber,
        position,
        password,
        confirmPassword,
      );
      if (isValidate) {
        Pops.startLoading();
        UserCredential userCredential = await auth
            .createUserWithEmailAndPassword(email: email, password: password);
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
      }
    } on FirebaseAuthException catch (e) {
      Pops.stopLoading();
      if (e.code == 'email-already-in-use') {
        Pops.showToast('Email already in use');
        return;
      } else if (e.code == 'weak-password') {
        Pops.showToast('Weak password');
        return;
      } else if (e.code == 'wrong-password') {
        Pops.showToast('Wrong password');
        return;
      } else if (e.code == 'invalid-email') {
        Pops.showToast('Invalid email');
        return;
      } else if (e.code == 'user-not-found') {
        Pops.showToast('User not found');
        return;
      }
    } catch (e) {
      Pops.stopLoading();
      Pops.showToast('Something went wrong');
      return;
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      bool isValidate = validateLogin(email, password);
      if (isValidate) {
        Pops.startLoading();
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          Get.offNamed(AppRoutes.customBottomNavBar);
        }
      }
    } on FirebaseAuthException catch (e) {
      Pops.stopLoading();
      if (e.code == 'wrong-password') {
        Pops.showToast('Wrong password');
      } else if (e.code == 'invalid-email') {
        Pops.showToast('Invalid email');
      } else if (e.code == 'user-not-found') {
        Pops.showToast('User not found');
        return;
      }
    } catch (e) {
      Pops.stopLoading();
      Pops.showToast('Something went wrong');
      return;
    }
  }
}
