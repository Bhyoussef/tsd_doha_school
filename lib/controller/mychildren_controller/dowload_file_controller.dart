import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constant/constant.dart';
import '../../theme/app_colors.dart';

class FileDownloadController extends GetxController {
  Future<void> downloadFile(int uid, String fileId, String fileName) async {
    try {
      final response = await http.post(
        Uri.parse('${Res.host}/proschool/giveme_base64'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "jsonrpc": "2.0",
          "method": "call",
          "uid": uid,
          "params": {
            "ID": fileId,
          },
        }),
      );

      final jsonData = jsonDecode(response.body);
      final base64Data = jsonData['result'][0]['base64'][0]['file'];
      final fileBytes = base64Decode(base64Data);

      final status= await Permission.storage.request();

 if(status.isGranted){
   final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$fileName';

  final File file = File(filePath);
  await file.writeAsBytes(fileBytes, flush: true);


 showDialog(
   context: Get.overlayContext!,
   builder: (context) {
     return AlertDialog(
       title:  Text('downloadcompleted'.tr),
       content: Text('filesavedat'.tr +filePath),
       actions: [
         TextButton(
           onPressed: () {
             Get.back();
           },
           child: Text(
             'ok'.tr,
             style: TextStyle(
               color: primarycolor,
               fontWeight: FontWeight.bold,
             ),
           ),
         ),
       ],
     );
   },
 );
 }else{
   if (kDebugMode) {
     print('no permission');
   }
 }


    } catch (error) {
      showDialog(
        context: Get.overlayContext!,
        builder: (context) {
          return AlertDialog(
            title:  Text('error'.tr),
            content:  Text('failedtodownloadfile'.tr),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  'ok'.tr,
                  style: TextStyle(color: primarycolor),
                ),
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
