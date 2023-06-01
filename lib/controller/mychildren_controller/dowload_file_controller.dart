import 'dart:convert';
import 'dart:io';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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

      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        // Add more permissions to request here if needed.
      ].request();

      if (statuses[Permission.storage]!.isGranted) {
        var dir = await DownloadsPathProvider.downloadsDirectory;
        if (dir != null) {
          String saveName = fileName;
          String savePath = "${dir.path}/$saveName";
          print(savePath);

          try {
            await File(savePath).writeAsBytes(fileBytes, flush: true);
            showDialog(
              context: Get.overlayContext!,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Download Completed'),
                  content: Text('File saved at: $savePath'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child:  Text(
                        'OK',
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
          } on IOException catch (e) {
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
                      child:  Text(
                        'OK',
                        style: TextStyle(color: primarycolor),
                      ),
                    ),
                  ],
                );
              },
            );
            if (kDebugMode) {
              print(e);
            }
          }
        }
      } else {
        print("No permission to read and write.");
      }
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
                child:  Text(
                  'OK',
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




  Future<void> download( String attachement ,String attachementName) async {
    try {



      final fileBytes = base64Decode(attachement);
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,

      ].request();

      if (statuses[Permission.storage]!.isGranted) {
        var dir = await DownloadsPathProvider.downloadsDirectory;
        if (dir != null) {
          String saveName = attachementName;
          String savePath = "${dir.path}/$saveName";
          if (kDebugMode) {
            print(savePath);
          }

          try {
            await File(savePath).writeAsBytes(fileBytes, flush: true);
            showDialog(
              context: Get.overlayContext!,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Download Completed'),
                  content: Text('File saved at: $savePath'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child:  Text(
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
          } on IOException catch (e) {
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
                      child:  Text(
                        'ok'.tr,
                        style: TextStyle(color: primarycolor),
                      ),
                    ),
                  ],
                );
              },
            );
            if (kDebugMode) {
              print(e);
            }
          }
        }
      } else {
        if (kDebugMode) {
          print("No permission to read and write.");
        }
      }
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
                child:  Text(
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


