import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/constants.dart';

import '../../models/file_model.dart';

class SearchController extends GetxController {
  // static SearchController instance = Get.find();
  RxList<String> itemsTitles = RxList();
  RxString dropdownValue = 'العنوان'.obs;
  RxList<FileModel> itemsList = RxList<FileModel>([]);
  RxList<FileModel> searchedItemsList = RxList<FileModel>([]);
  RxBool isSearching = false.obs;
  final searchTextController = TextEditingController();

  getItems() async {
    itemsList.value = await dbController.readFiles();
    // for (FileModel x in itemsList) {
    //   if (x.fileTitle != null) {
    //     itemsTitles.add(x.fileTitle!);
    //   }
    // }
  }
}
