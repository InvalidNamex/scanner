import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/file_model.dart';

class ReportsController extends GetxController {
  static ReportsController instance = Get.find();

  Future<String> get externalPath async {
    Directory? directory = await getExternalStorageDirectory();
    return directory?.path ?? '';
  }

  Future<File> get externalFile async {
    final directory = await getExternalStorageDirectory();
    return File('${directory?.path}/complain.pdf');
  }

  Future createPDF(FileModel filex) async {
    try {
      Get.defaultDialog(title: '', content: const CircularProgressIndicator());
      final pdf = pw.Document();
      final fontData =
          await rootBundle.load('assets/NotoNaskhArabic-Regular.ttf');
      final font = pw.Font.ttf(fontData.buffer.asByteData());
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text(filex.fileTitle ?? '',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                        font: font,
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold),
                    textDirection: pw.TextDirection.rtl),
                pw.Text('رقم الملف/ ${filex.counterCode}',
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 16,
                    ),
                    textDirection: pw.TextDirection.rtl),
                pw.Text('الموضوع',
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(font: font, fontSize: 16),
                    textDirection: pw.TextDirection.rtl),
                pw.Text(filex.fileSubject ?? '',
                    style: pw.TextStyle(font: font, fontSize: 16),
                    textDirection: pw.TextDirection.rtl),
              ],
            );
          }));

      final file = await externalFile;
      await file.writeAsBytes(await pdf.save());
      final path = file.path;

      Get.back();
      OpenFile.open(path);
    } catch (e) {
      Get.defaultDialog(
        title: 'خطأ',
        middleText: 'حدث خطأ أثناء تصدير ملف PDF',
      );
    }
  }
}
