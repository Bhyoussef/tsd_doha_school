import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../constant/constant.dart';
import '../../theme/app_colors.dart';

class FileDownloadController extends GetxController {

  Future<void> downloadFile(
      int parentId, String fileId, String fileName) async {
    try {
      final response = await http.post(
        Uri.parse('${Res.host}/proschool/giveme_base64'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "jsonrpc": "2.0",
          "method": "call",
          "uid": parentId,
          "params": {
            "ID": fileId,
          },
        }),
      );
      final jsonData = jsonDecode(response.body);
      final base64Data = jsonData['result'][0]['base64'][0]['file'];
      final fileBytes = base64Decode(base64Data);
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName.pdf';
      await File(filePath).writeAsBytes(fileBytes);
      showDialog(
        context: Get.overlayContext!,
        builder: (context) {
          return AlertDialog(
            title: Text('Download Completed'),
            content: Text('File saved at: $filePath'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('OK',style: TextStyle(color: primarycolor,fontWeight: FontWeight.bold),),
              ),
            ],
          );
        },
      );
    } catch (error) {
      showDialog(
        context: Get.overlayContext!,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to download the file.'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('OK',style: TextStyle(color: primarycolor),),
              ),
            ],
          );
        },
      );
      if (kDebugMode) {
        print(error);
      }
    }
  }




}
