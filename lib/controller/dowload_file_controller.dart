import 'dart:convert';
import 'dart:io';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constant/constant.dart';
import '../theme/app_colors.dart';
import '../utils/pdf_viewer.dart';

class FileDownloadController extends GetxController {
  bool isDownloading = false;
  bool isAlertDialogVisible = false;
  BuildContext? alertDialogContext;

  Future<void> downloadFile(int uid, String fileId, String fileName) async {
    try {
      isDownloading = true;
      showDownloadProgressToast();
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
            Get.back();
            isAlertDialogVisible = true;
            showDialog(
              context: Get.overlayContext!,
              builder: (context) {
                return AlertDialog(
                  title: Text('downloadcompleted'.tr),
                  actions: [
                    TextButton(
                      onPressed: () {
                        openDownloadedFile(savePath);
                        if (isAlertDialogVisible && alertDialogContext != null) {
                          Navigator.of(alertDialogContext!).pop();
                          isAlertDialogVisible = false;
                        }
                        Get.back();


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
                  title: Text('Error'),
                  content: Text('Failed to download file.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'OK',
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
                title: Text('Error'),
                content: Text('Failed to download file.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
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
    } catch (error) {
      showDialog(
        context: Get.overlayContext!,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to download file.'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
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
    } finally {
      isDownloading = false;
    }
  }

  Future<void> download(String attachment, String attachmentName) async {
    try {
      isDownloading = true;
      showDownloadProgressToast();
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
            Get.back();

            showDialog(
              context: Get.overlayContext!,
              builder: (context) {
                return AlertDialog(
                  title: Text('downloadcompleted'.tr),
                  actions: [
                    TextButton(
                      onPressed: () {
                        openDownloadedFile(savePath);
                        Get.back();
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
                  title: Text('Error'),
                  content: Text('Failed to download file.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
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
          }
        } on IOException catch (e) {
          showDialog(
            context: Get.overlayContext!,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Failed to download file.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
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
    } catch (error) {
      showDialog(
        context: Get.overlayContext!,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to download file.'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
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
    } finally {
      isDownloading = false;
    }
  }

  Future<String> getUniqueFilePath(String directory, String fileName) async {
    String filePath = '$directory/$fileName';
    File file = File(filePath);
    int fileNumber = 1;

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

  void showDownloadProgressToast() {
    Get.snackbar(
      'downloading'.tr,
      'filedownloaded'.tr,
      duration: Duration(seconds: 3),
      backgroundColor: Colors.grey[800],
      colorText: Colors.white,
      overlayColor: Colors.black54,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(20),
    );
  }


  Future<void> openDownloadedFile(String filePath) async {
    if (Platform.isIOS) {
      await OpenFile.open(filePath);
    } else if (Platform.isAndroid) {
      String fileExtension = path.extension(filePath).toLowerCase();
      if (fileExtension == '.pdf') {
       await  Get.to(() => PDFViwer(path: filePath));
       if (isAlertDialogVisible && alertDialogContext != null) {
         Navigator.of(alertDialogContext!).pop();
         isAlertDialogVisible = false;
       }
      } else {
        await OpenFile.open(filePath);
      }
    }
  }



}
