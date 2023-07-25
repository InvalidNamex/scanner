import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:scanner/screens/image_full_screen.dart';
import 'package:get/get.dart';

class AttachmentPreviewScreen extends StatelessWidget {
  final List<File> images;
  const AttachmentPreviewScreen({Key? key, required this.images})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('عرض المرفقات'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: CarouselSlider.builder(
                itemBuilder: (context, index, relIndex) => InkWell(
                  onTap: () {
                    Get.to(() => ImageFullScreen(
                          image: images[index],
                        ));
                  },
                  child: Image.file(
                    images[index],
                    fit: BoxFit.fill,
                  ),
                ),
                itemCount: images.length,
                options: CarouselOptions(
                    height: MediaQuery.of(context).size.height,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
