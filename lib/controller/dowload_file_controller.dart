import 'dart:convert';
import 'dart:io';
import 'package:android_intent/android_intent.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tsdoha/constant/constant.dart';
import 'package:tsdoha/theme/app_colors.dart';
import 'package:tsdoha/utils/image_redear.dart';
import 'package:tsdoha/utils/pdf_viewer.dart';
import 'package:url_launcher/url_launcher.dart';



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
                        openDownloadedFile(savePath,context);
                        //Get.back();
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
                        openDownloadedFile(savePath,context);
                        //Get.back();
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
            title: Text('Error'),
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
    showDialog(
      context: Get.overlayContext!,
      builder: (context) {
        return AlertDialog(
          title:  Center(
              child: Column(
                children: [
                  CircularProgressBar(color: primarycolor,),
                  Text('downloading'.tr,)
                ],
              ))

        );
      },
    );
  }



  Future<void> openDownloadedFile(String filePath, BuildContext context) async {
    if (Platform.isIOS) {
      Get.back();
      await OpenFile.open(filePath);
    } else if (Platform.isAndroid) {
      String fileExtension = path.extension(filePath).toLowerCase();
      if (fileExtension == '.pdf') {
        Navigator.pop(context);
        await Get.to(() => PDFViwer(path: filePath));
      } else if (fileExtension == '.jpg' ||
          fileExtension == '.jpeg' ||
          fileExtension == '.png') {
        Get.back();
        final File file = File(filePath);
        final image = file.readAsBytesSync();
        Get.to(() => ImageReaderPage(imageBytes: image));
      } else {
        Get.back();
        bool fileOpened = await openFileInFolder(filePath);
        if (!fileOpened) {
          print('Error opening the file in folder.');
        }
      }
    }
  }

  Future<bool> openFileInFolder(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          withData: false,
          type: FileType.any,
        );
        if (result != null && result.files.isNotEmpty) {
          final openedFile = File(result.files.first.path!);
          await OpenFile.open(openedFile.path);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }





}
