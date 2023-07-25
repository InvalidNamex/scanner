import 'package:flutter/material.dart';
import 'dart:io';

class ImageFullScreen extends StatelessWidget {
  final File image;
  const ImageFullScreen({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              child: Image.file(
                image,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
