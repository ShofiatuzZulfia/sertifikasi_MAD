import 'dart:developer';

import 'package:moments/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  var obscureText = true.obs;

  Stream<User?> get streamAuthStatus =>
      FirebaseAuth.instance.authStateChanges();

  bool isUserLoggedIn() => FirebaseAuth.instance.currentUser != null;

  void togglePasswordView() {
    obscureText.value = !obscureText.value;
  }

  void login(String email, String password) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Check if email or password is empty
    if (email.isEmpty && password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter email and password',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      );
      return;
    } else if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter email',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      );
      return;
    } else if (password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter password',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Check if email is verified
      if (userCredential.user!.emailVerified) {
        Get.snackbar(
          'Success',
          'User logged in successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(12),
        );
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar(
          'Error',
          'Please verify your email',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(12),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Memeriksa email dan password di firebase
      if (e.code == 'user-not-found') {
        Get.snackbar(
          'Error',
          'Email not found in Firebase.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(12),
        );
        return;
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
          'Error',
          'Incorrect password provided.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(12),
        );
        return;
      } else if (e.code == 'too-many-requests') {
        Get.snackbar(
          'Error',
          'Too many requests. Try again later.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(12),
        );
      } else {
        Get.snackbar(
          'Error',
          'Check email and password. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(12),
        );
      }
      log("FirebaseAuthException: ${e.code}");
    } catch (e) {
      log("Error: $e");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
