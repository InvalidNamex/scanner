import 'package:flutter/material.dart';
import '../widgets/search_widget/home_tile_widget.dart';
import '/controllers/home_controller.dart';
import 'package:get/get.dart';
import '../constants.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.populateFilesList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('توثيق'),
        centerTitle: true,
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.toNamed('/new-file');
            },
            child: const Icon(Icons.add),
          ),
        ],
        leading: ElevatedButton(
          onPressed: () {
            Get.toNamed('/search');
          },
          child: const Icon(Icons.search),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > pageWidth) {
            return Container(
              color: Colors.grey,
              child: Center(
                child: Container(
                  width: pageWidth,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: buildContent(context, controller),
                ),
              ),
            );
          } else {
            return buildContent(context, controller);
          }
        },
      ),
    );
  }
}

Widget buildContent(context, HomeController controller) => homeTile(controller);

Container homeTile(HomeController controller) {
  return Container(
    color: Colors.white,
    child: Obx(
      () => controller.filesList.isEmpty
          ? Center(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/docs.png',
                  height: 70,
                  width: 70,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'فارغ',
                  style: TextStyle(fontSize: 22),
                ),
              ],
            ))
          : ListView.builder(
              itemCount: controller.filesList.length,
              itemBuilder: (BuildContext context, int index) => Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue)),
                child: homeTileWidget(controller, index),
              ),
            ),
    ),
  );
}
