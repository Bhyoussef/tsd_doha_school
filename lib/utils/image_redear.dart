import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/theme/app_colors.dart';
import 'package:tsdoha/views/home/home_screen.dart';


class ImageReaderPage extends StatelessWidget {
  final Uint8List imageBytes;

  ImageReaderPage({required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: primarycolor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: CupertinoColors.white),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Get.offAll(() => HomeScreen());
              },
              child: Image.asset(
                'assets/imgs/tsdIcon.png',
                width: 40,
                height: 40,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Image(
          image: MemoryImage(imageBytes),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
