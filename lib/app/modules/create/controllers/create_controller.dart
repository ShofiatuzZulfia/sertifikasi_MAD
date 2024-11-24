import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CreateController extends GetxController {
  late TextEditingController titleController;
  late TextEditingController momentsController;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxString username = ''.obs;

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

  void addData(String title, String moments, String emoji) async {
    try {
      await firestore.collection('posts').add({
        'emoji': emoji,
        'title': title,
        'moments': moments,
        'createdAt': FieldValue.serverTimestamp(),
        'user': username.value,
      });

      Get.back();
      Get.snackbar(
        'Success',
        'Data added successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(12),
      );
      titleController.clear();
      momentsController.clear();
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() {
    titleController = TextEditingController();
    momentsController = TextEditingController();
    fetchUsername();
    super.onInit();
  }

  @override
  void onClose() {
    titleController.dispose();
    momentsController.dispose();
    super.onClose();
  }
}
