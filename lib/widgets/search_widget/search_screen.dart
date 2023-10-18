import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/widgets/search_widget/home_tile_widget.dart';
import '../../constants.dart';

class SearchScreen extends GetView<SearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    searchController.getItems();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          Obx(
            () => DropdownButton<String>(
              dropdownColor: Colors.blue,
              value: searchController.dropdownValue.value,
              items: <String>['رقم الملف', 'الموضوع', 'العنوان']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                searchController.dropdownValue(newValue!);
              },
            ),
          )
        ],
        title: Obx(() => searchController.isSearching.value
            ? _buildSearchField()
            : _buildAppBarTitle(context)),
        leading: _buildAppBarActions(context),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > pageWidth) {
            return Center(
              child: Container(
                width: pageWidth,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: buildContent(context),
              ),
            );
          } else {
            return buildContent(context);
          }
        },
      ),
    );
  }
}

Widget buildContent(context) {
  final controller = searchController;
  return Container(
    color: Colors.white,
    child: Obx(
      () => controller.searchedItemsList.isEmpty
          ? const Center(child: Text('فارغ'))
          : ListView.builder(
              itemCount: controller.searchedItemsList.length,
              itemBuilder: (BuildContext context, int index) => Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue)),
                child: homeTileWidget(homeController, index),
              ),
            ),
    ),
  );
}

Widget _buildSearchField() {
  return TextField(
    keyboardType: searchController.dropdownValue.value == 'رقم الملف'
        ? TextInputType.number
        : TextInputType.text,
    style: const TextStyle(color: Colors.white),
    autofocus: true,
    controller: searchController.searchTextController,
    cursorColor: Colors.white,
    decoration: const InputDecoration(
      hintText: 'بحث',
      hintStyle: TextStyle(color: Colors.white),
      border: InputBorder.none,
    ),
    onChanged: (searchedProduct) {
      RxString _value = searchController.dropdownValue;
      if (_value.value == 'رقم الملف') {
        searchController.searchedItemsList.value = searchController.itemsList
            .where((item) =>
                item.counterCode!.toString().contains(searchedProduct))
            .toList();
      } else if (_value.value == 'الموضوع') {
        searchController.searchedItemsList.value = searchController.itemsList
            .where((item) =>
                item.fileSubject!.toLowerCase().contains(searchedProduct))
            .toList();
      } else {
        searchController.searchedItemsList.value = searchController.itemsList
            .where((item) =>
                item.fileTitle!.toLowerCase().contains(searchedProduct))
            .toList();
      }
    },
  );
}

Widget _buildAppBarTitle(BuildContext context) {
  return GestureDetector(
    onTap: () => _startSearch(context),
    child: const Text('بحث عن ملف...'),
  );
}

_startSearch(BuildContext context) {
  ModalRoute.of(context)
      ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
  searchController.isSearching(true);
}

_stopSearching() {
  searchController.searchTextController.clear();
  searchController.searchedItemsList.clear();
  searchController.isSearching(false);
}

Widget _buildAppBarActions(BuildContext context) {
  return Obx(() => searchController.isSearching.value
      ? IconButton(
          onPressed: () {
            searchController.searchTextController.clear();
            searchController.searchedItemsList.clear();
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.clear,
            color: Colors.white,
          ))
      : IconButton(
          onPressed: () => _startSearch(context),
          icon: const Icon(
            Icons.search,
            color: Colors.white,
          )));
}

// ExpansionTile(
// childrenPadding: const EdgeInsets.all(5),
// tilePadding: const EdgeInsets.all(5),
// collapsedBackgroundColor: const Color(0x10000000),
// leading: Row(
// mainAxisSize: MainAxisSize.min,
// children: [
// IconButton(
// onPressed: () async {
// int? id =
// controller.searchedItemsList[index].fileId;
// if (id != null) {
// await dbController.deleteFile(id);
// await homeController.deleteFile(controller
//     .searchedItemsList[index].fileImage);
// await await controller.getItems();
// }
// },
// icon: const Icon(
// Icons.delete_outline,
// color: Colors.red,
// )),
// ],
// ),
// title: Text(
// 'العنوان:  ${controller.searchedItemsList[index].fileTitle}',
// style: const TextStyle(
// color: Colors.black,
// fontSize: 18,
// fontWeight: FontWeight.bold),
// ),
// subtitle: Text(
// ' رقم العداد: ${controller.searchedItemsList[index].counterCode}',
// style: const TextStyle(fontSize: 16),
// maxLines: 1,
// ),
// children: [
// Row(
// mainAxisSize: MainAxisSize.max,
// children: [
// Text(
// ' موضوع الملف:\n ${controller.searchedItemsList[index].fileSubject}',
// style: const TextStyle(
// fontSize: 16, fontWeight: FontWeight.w700),
// textDirection: TextDirection.rtl,
// textAlign: TextAlign.start,
// maxLines: 10,
// ),
// ],
// ),
// controller.searchedItemsList[index].fileImage != ''
// ? ElevatedButton(
// onPressed: () {
// File image = File(controller
//     .searchedItemsList[index].fileImage!);
// Get.defaultDialog(
// title: 'صورة المرفق',
// content: Image.file(
// image,
// fit: BoxFit.fill,
// ));
// },
// child: const Text('عرض المرفق'))
//     : const Text(
// 'لا توجد مرفقات لهذا الملف',
// style: TextStyle(color: Colors.red),
// ),
// Text(
// 'التاريخ: ${controller.searchedItemsList[index].fileDate}',
// style: const TextStyle(
// color: Colors.blue,
// fontSize: 18,
// fontWeight: FontWeight.w700),
// )
// ],
// )
