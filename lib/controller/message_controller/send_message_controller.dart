import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/personal_model.dart';
import '../../services/message.dart';
import '../../services/personal.dart';
import '../../utils/shared_preferences.dart';

class SendMessageController extends GetxController {
  var selectedTo = RxString('');
  var selectedRecipient = RxString('');
  var subject = RxString('');
  var message = RxString('');
  final attachmentController = TextEditingController().obs;
  var teacherRecipients = <Personal>[].obs;
  var adminRecipients = <Personal>[].obs;
  var recipientVisible = RxBool(false);
  var isLoading = false.obs;


  @override
  void onInit() {
    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
      fetchRecipients(uid);
    });
    super.onInit();
  }

  Future<void> fetchRecipients(int uid) async {
    try {
      String type = '';
      if (selectedTo.value == 'T') {
        type = 'T';
      } else if (selectedTo.value == 'A') {
        type = 'A';
      }
      final recipientList = await ApiServicePersonal.getPersonal(uid, type);
      if (selectedTo.value == 'T') {
        teacherRecipients.value = recipientList;
        if (recipientList.isNotEmpty) {
          selectedRecipient.value = recipientList[0].name!;
        }
      } else if (selectedTo.value == 'A') {
        adminRecipients.value = recipientList;
        if (recipientList.isNotEmpty) {
          selectedRecipient.value = recipientList[0].name!;
        }
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<String?> createMessage(
      int parentId,
      String receiver,
      String subject,
      String message,
      String receiverId,
      String attachmentPath,
      ) async {
    try {
      isLoading(true);
      await ApiServiceMessage.createMessage(
        parentId,
        receiver,
        subject,
        message,
        receiverId,
        attachmentPath,
      );
    } finally {
      isLoading(false);
    }
    return null;
  }

  void addAttachment() {
    pickFile();
  }

  void removeAttachment() {
    attachmentController.value.text = '';
  }

  Future<void> pickFile() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final filePath = pickedFile.path;
      final selectedImg = filePath.split('/').last;
      convertToBase64(selectedImg);
    } else {
      // Handle case when no file is picked
    }
  }

  void convertToBase64(String path) async {
    final file = File(path);
    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);
    final imagePath = base64Image.split(',')[1];
    final selectedImgName = imagePath.split('/').last;
    attachmentController.value.text = selectedImgName;
  }
}
