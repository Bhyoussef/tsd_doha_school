import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:tsdoha/theme/app_colors.dart';
import 'package:tsdoha/views/home/home_screen.dart';

class PDFViwer extends StatefulWidget {
  final String path;
  const PDFViwer({super.key, required this.path});

  @override
  State<PDFViwer> createState() => _PDFViwerState();
}

class _PDFViwerState extends State<PDFViwer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.transparent,
        backgroundColor: primarycolor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color:CupertinoColors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Get.offAll(()=>HomeScreen());
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
      body: PDFView(
        filePath: widget.path,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
      ),
    );
  }
}
