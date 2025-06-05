import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../routes/app_pages.dart';

class LoginPageController extends GetxController with GetSingleTickerProviderStateMixin {

  // var UserName = TextEditingController();
  // var Password = TextEditingController();
  // var isLoading = false.obs;
  // final box = GetStorage();
  // var isLogged = false.obs;
  // late AnimationController animationController;
  // late Animation<double> animation;
  // var rememberMe = false.obs;
  // var Switch_page = false.obs;

    final box = GetStorage();
  var isLoading = false.obs;
  var isLogged = ''.obs;

  late AnimationController animationController;
  late Animation<double> animation;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    animation = Tween<double>(begin: 0,end: 30).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
    
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return; // User canceled
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Save user to Firestore
        await firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName,
          'email': user.email,
          'photoUrl': user.photoURL,
          'lastLogin': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        box.write('uid', user.uid);
        box.write('name', user.displayName);
        box.write('email', user.email);
        box.write('photoUrl', user.photoURL);
        box.write('isLogged', true);
        box.write('lastLogin', FieldValue.serverTimestamp());

        log(box.read('uid').toString());
        log(box.read('name').toString());
        log(box.read('email').toString());
        log(box.read('photoUrl').toString());
        log(box.read('isLogged').toString());
        // isLogged.value = true;

        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      log("Login Error: $e");
      Get.snackbar("Login Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }


}