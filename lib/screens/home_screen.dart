import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scanner/screens/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import '/screens/attachment_preview_screen.dart';
import '/controllers/home_controller.dart';
import 'package:get/get.dart';
import '../constants.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.populateFilesList();
    return Scaffold(
      backgroundColor: Colors.black,
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
            return Center(
              child: Container(
                width: pageWidth,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: buildContent(context, controller),
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

Widget buildContent(context, HomeController controller) => Container(
      color: Colors.white,
      child: Obx(
        () => controller.filesList.isEmpty
            ? const Center(child: Text('فارغ'))
            : ListView.builder(
                itemCount: controller.filesList.length,
                itemBuilder: (BuildContext context, int index) => Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue)),
                  child: ExpansionTile(
                    childrenPadding: const EdgeInsets.all(5),
                    tilePadding: const EdgeInsets.all(5),
                    collapsedBackgroundColor: const Color(0x10000000),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () async {
                              int? _id = controller.filesList[index].fileId;
                              if (_id != null) {
                                await dbController.deleteFile(_id);
                                await controller.deleteFile(
                                    controller.filesList[index].fileImage);
                                await await controller.populateFilesList();
                              }
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            )),
                      ],
                    ),
                    title: Text(
                      'العنوان:  ${controller.filesList[index].fileTitle}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      ' رقم الملف: ${controller.filesList[index].counterCode}',
                      style: const TextStyle(fontSize: 16),
                      maxLines: 1,
                    ),
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            ' موضوع الملف:\n ${controller.filesList[index].fileSubject}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.start,
                            maxLines: 10,
                          ),
                        ],
                      ),
                      controller.filesList[index].fileLink != null &&
                              controller.filesList[index].fileLink != ''
                          ? ElevatedButton(
                              onPressed: () async {
                                String? url =
                                    controller.filesList[index].fileLink;
                                Uri uri = Uri.parse(url!);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                } else {
                                  Get.snackbar(
                                      'رابط معطوب', 'فشل زيارة الرابط');
                                }
                              },
                              child: const Text('زيارة الرابط'))
                          : const Text(
                              'لا يوجد رابط لهذا الملف',
                              style: TextStyle(color: Colors.red),
                            ),
                      controller.filesList[index].fileImage != '' &&
                              controller.filesList[index].fileImage != null
                          ? ElevatedButton(
                              onPressed: () {
                                String _x =
                                    controller.filesList[index].fileImage!;
                                List<File> imageFiles = [];
                                List<String> images = [];
                                _x = _x.replaceAll(']', '');
                                _x = _x.replaceAll('[', '');
                                images = _x.split(", ");

                                for (String image in images) {
                                  File imageFile = File(image);
                                  imageFiles.add(imageFile);
                                }
                                if (_x.substring(_x.length - 3).toLowerCase() !=
                                    'mp4') {
                                  Get.to(() => AttachmentPreviewScreen(
                                      images: imageFiles));
                                } else {
                                  Get.to(() => const VideoPlayerWidget(),
                                      arguments: [_x]);
                                }
                              },
                              child: const Text('عرض المرفق'))
                          : const Text(
                              'لا توجد مرفقات لهذا الملف',
                              style: TextStyle(color: Colors.red),
                            ),
                      Text(
                        'التاريخ: ${controller.filesList[index].fileDate}',
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
