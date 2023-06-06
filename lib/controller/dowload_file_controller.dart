import 'dart:convert';
import 'dart:io';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constant/constant.dart';
import '../theme/app_colors.dart';

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
      ].request();

      var dir;

      if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory();
      } else {
        dir = await DownloadsPathProvider.downloadsDirectory;
      }
      if (dir != null) {
        String savePath = await getUniqueFilePath(dir.path, fileName);
        if (kDebugMode) {
          print(savePath);
        }

        try {
          await File(savePath).writeAsBytes(fileBytes, flush: true);

          final file = File(savePath);
          if (await file.exists()) {
            showDialog(
              context: Get.overlayContext!,
              builder: (context) {
                return AlertDialog(
                  title: Text('downloadcompleted'.tr),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                        OpenFile.open(savePath);
                      },
                      child: Text(
                        'open'.tr,
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
          } else {
            showDialog(
              context: Get.overlayContext!,
              builder: (context) {
                return AlertDialog(
                  title: Text('error'.tr),
                  content: Text('failedtodownloadfile'.tr),
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
          }
        } on IOException catch (e) {
          showDialog(
            context: Get.overlayContext!,
            builder: (context) {
              return AlertDialog(
                title: Text('error'.tr),
                content: Text('failedtodownloadfile'.tr),
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
            print(e);
          }
        }
      }
    } catch (error) {
      showDialog(
        context: Get.overlayContext!,
        builder: (context) {
          return AlertDialog(
            title: Text('error'.tr),
            content: Text('failedtodownloadfile'.tr),
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

  Future<void> download(String attachment, String attachmentName) async {
    try {
      final fileBytes = base64Decode(attachment);
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();

      var dir;


      if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory();
      } else {
        dir = await DownloadsPathProvider.downloadsDirectory;
      }
      if (dir != null) {
        String savePath = await getUniqueFilePath(dir.path, attachmentName);
        if (kDebugMode) {
          print(savePath);
        }

        try {
          await File(savePath).writeAsBytes(fileBytes, flush: true);

          final file = File(savePath);
          if (await file.exists()) {
            showDialog(
              context: Get.overlayContext!,
              builder: (context) {
                return AlertDialog(
                  title: Text('downloadcompleted'.tr),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                        OpenFile.open(savePath);
                      },
                      child: Text(
                        'open'.tr,
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
          } else {
            showDialog(
              context: Get.overlayContext!,
              builder: (context) {
                return AlertDialog(
                  title: Text('error'.tr),
                  content: Text('failedtodownloadfile'.tr),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'ok'.tr,
                        style: TextStyle(
                            color: primarycolor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        } on IOException catch (e) {
          showDialog(
            context: Get.overlayContext!,
            builder: (context) {
              return AlertDialog(
                title: Text('error'.tr),
                content: Text('failedtodownloadfile'.tr),
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
            print(e);
          }
        }
      }
    } catch (error) {
      showDialog(
        context: Get.overlayContext!,
        builder: (context) {
          return AlertDialog(
            title: Text('error'.tr),
            content: Text('failedtodownloadfile'.tr),
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

  Future<String> getUniqueFilePath(String directory, String fileName) async {
    String filePath = '$directory/$fileName';
    File file = File(filePath);
    int fileNumber = 1;

    // Check if the file already exists
    while (await file.exists()) {
      String newFileName =
          '${getFileNameWithoutExtension(fileName)}_$fileNumber.${getFileExtension(fileName)}';
      filePath = '$directory/$newFileName';
      file = File(filePath);
      fileNumber++;
    }

    return filePath;
  }

  String getFileNameWithoutExtension(String fileName) {
    int extensionIndex = fileName.lastIndexOf('.');
    if (extensionIndex != -1) {
      return fileName.substring(0, extensionIndex);
    }
    return fileName;
  }

  String getFileExtension(String fileName) {
    int extensionIndex = fileName.lastIndexOf('.');
    if (extensionIndex != -1 && extensionIndex < fileName.length - 1) {
      return fileName.substring(extensionIndex + 1);
    }
    return '';
  }
}
