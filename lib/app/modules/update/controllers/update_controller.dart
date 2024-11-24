import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateController extends GetxController {
  late TextEditingController titleController;
  late TextEditingController momentsController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Object?>> getData(String docID) async {
    DocumentReference docRef = firestore.collection('posts').doc(docID);
    return docRef.get();
  }

  void updateData(
      String docID, String emoji, String title, String moments) async {
    try {
      await firestore.collection('posts').doc(docID).update({
        'emoji': emoji,
        'title': title,
        'moments': moments,
      });

      Get.back();
      Get.snackbar(
        'Success',
        'Data updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      );
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Failed updating data',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      );
    }
  }

  @override
  void onInit() {
    titleController = TextEditingController();
    momentsController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    titleController.dispose();
    momentsController.dispose();
    super.onClose();
  }
}
