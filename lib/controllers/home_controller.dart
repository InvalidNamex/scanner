import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../models/file_model.dart';
import 'dart:io';

class HomeController extends GetxController {
  static HomeController instance = Get.find();
  RxBool isLoading = false.obs;
  RxList<FileModel> filesList = RxList<FileModel>([]);
  TextEditingController fileTitleController = TextEditingController();
  TextEditingController fileSubjectController = TextEditingController();
  TextEditingController fileImageController = TextEditingController();
  TextEditingController fileCounterCode = TextEditingController();
  final newFileFormKey = GlobalKey<FormState>();
  Rx<DateTime> joinDate = DateTime.now().obs;

  Future populateFilesList() async {
    isLoading(true);
    filesList.value = await dbController.readFiles();
    isLoading(false);
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: joinDate.value,
        firstDate: DateTime(2010),
        lastDate: DateTime.now());
    if (picked != null && picked != joinDate.value) {
      joinDate.value = picked;
    }
  }

  Future<void> deleteFile(String? path) async {
    if (path != null) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }
}
