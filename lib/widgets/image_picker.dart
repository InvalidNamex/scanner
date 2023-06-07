import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

Future<String?> pickingImage(ImageSource source) async {
  try {
    //TODO: Pick image then save it to file after that copy file path to database
    ImagePicker image = ImagePicker();
    XFile? pickedImage = await image.pickImage(source: source);

    if (pickedImage != null) {
      final pickedPath = pickedImage.path;
      final directory = await getExternalStorageDirectory();
      final imageDirectory = Directory(directory!.path);
      String imageString = imageDirectory.path;
      final path =
          join(imageString, '${DateTime.now().millisecondsSinceEpoch}.png');
      final bytes = File(pickedPath).readAsBytesSync();
      final newFile = File(path);
      await newFile.writeAsBytes(bytes);
      return newFile.path;
    }
    return null;
  } catch (e) {
    Get.snackbar('Error', e.toString());
    print(e.toString());
    return null;
  }
}
