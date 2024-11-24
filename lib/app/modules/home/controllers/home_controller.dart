import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moments/app/modules/login/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  var username = ''.obs;
  RxString users = ''.obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsername();
  }

  Stream<QuerySnapshot<Object?>> streamData() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt',
            descending: true) // Mengurutkan berdasarkan createdAt terbaru
        .snapshots();
  }

  void fetchUsername() async {
    User? user = auth.currentUser;
    if (user != null) {
      DocumentSnapshot userData =
          await firestore.collection('users').doc(user.uid).get();
      username.value = userData['username'] ?? 'Guest';
    } else {
      username.value = 'Guest';
    }
  }

  void deleteData(String docID) async {
    try {
      DocumentSnapshot docSnapshot =
          await firestore.collection('posts').doc(docID).get();
      String? postUsername = docSnapshot['user'];

      if (postUsername == username.value) {
        Get.defaultDialog(
          title: "Delete Post",
          middleText: "Are you sure you want to delete this post?",
          onConfirm: () async {
            await firestore.collection('posts').doc(docID).delete();
            Get.back();
            Get.snackbar(
              'Success',
              'Data deleted successfully',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(12),
            );
          },
          textConfirm: "Yes, I'm sure",
          textCancel: "No",
        );
      } else {
        Get.defaultDialog(
          title: "Akses Ditolak",
          middleText:
              "Anda tidak bisa menghapus postingan ini karena bukan milik Anda.",
          textConfirm: "OK",
          onConfirm: () => Get.back(),
        );
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Cannot delete this post',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      );
    }
  }

  void updateData(String docID, String title, String description) async {
    try {
      await firestore.collection('posts').doc(docID).update({
        'title': title,
        'description': description,
      });
      Get.snackbar(
        'Success',
        'Post updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      );
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Failed to update post',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      );
    }
  }

  void logout() async {
    await auth.signOut();
    Get.off(() => LoginView());
  }
}
