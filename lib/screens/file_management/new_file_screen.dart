import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scanner/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scanner/widgets/image_picker.dart';
import '../../constants.dart';
import '../../models/file_model.dart';

class NewFileScreen extends GetView<HomeController> {
  const NewFileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('إضافة ملف جديد'),
        centerTitle: true,
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
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Form(
        key: controller.newFileFormKey,
        child: ListView(
          children: [
            //file_Counter_code
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: controller.fileCounterCode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  labelText: 'رقم العداد',
                  prefixIcon: Icon(
                    Icons.access_time_outlined,
                    color: Colors.blue,
                  ),
                  hintText: 'ادخل رقم العداد',
                ),
              ),
            ),
            //file_title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controller.fileTitleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  labelText: 'عنوان الملف',
                  prefixIcon: Icon(
                    Icons.subtitles_outlined,
                    color: Colors.blue,
                  ),
                  hintText: 'قم بكتابة عنوان',
                ),
              ),
            ),
            //file_subject
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                maxLines: 15,
                controller: controller.fileSubjectController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  labelText: 'موضوع الملف',
                  prefixIcon: Icon(
                    Icons.subject_outlined,
                    color: Colors.blue,
                  ),
                  hintText: 'قم بكتابة الموضوع',
                ),
              ),
            ),
            //file_date
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'تاريخ الملف',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue)),
                    onPressed: () => controller.selectDate(context),
                    child: Obx(
                      () => Text(DateFormat('dd-MM-yyyy')
                          .format(controller.joinDate.value)),
                    ),
                  ),
                ],
              ),
            ),
            //file_image
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5)),
              child: InkWell(
                onTap: () async {
                  ImageSource? _source;
                  Get.defaultDialog(
                      title: 'مصدر الصورة؟',
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(25)),
                            child: IconButton(
                                onPressed: () async {
                                  _source = ImageSource.camera;
                                  String? _x = await pickingImage(_source!);
                                  if (_x != null) {
                                    controller.fileImageController.text = _x;
                                  }
                                  Get.back();
                                },
                                icon: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.blue,
                                )),
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(25)),
                            child: IconButton(
                                onPressed: () async {
                                  _source = ImageSource.gallery;
                                  String? _x = await pickingImage(_source!);
                                  if (_x != null) {
                                    controller.fileImageController.text = _x;
                                  }
                                  Get.back();
                                },
                                icon: const Icon(
                                  Icons.image_outlined,
                                  color: Colors.blue,
                                )),
                          ),
                        ],
                      ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'صورة المرفق',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Icon(
                      Icons.attach_file,
                      size: 30,
                      color: Colors.blue,
                    )
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.newFileFormKey.currentState!.validate()) {
                  try {
                    await dbController.createFile(FileModel(
                        fileTitle: controller.fileTitleController.text,
                        fileSubject: controller.fileSubjectController.text,
                        fileDate: DateFormat('dd-MM-yyyy')
                            .format(controller.joinDate.value),
                        fileImage: controller.fileImageController.text,
                        counterCode: controller.fileCounterCode.text));
                    controller.fileTitleController.clear();
                    controller.fileSubjectController.clear();
                    controller.fileCounterCode.clear();
                    controller.fileImageController.clear();
                    controller.joinDate.value = DateTime.now();
                    await controller.populateFilesList();
                    Get.snackbar('تم الحفظ', 'تم حفظ الملف بنجاح');
                  } catch (e) {
                    Get.snackbar('حدث خطأ', e.toString());
                  }
                }
              },
              child: const Text('حفظ الملف'),
            )
          ],
        ),
      ),
    );
