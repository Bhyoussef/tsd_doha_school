import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsdoha/model/send_message_model.dart';
import 'package:tsdoha/model/message_sent_model.dart';
import 'package:tsdoha/services/message.dart';
import 'package:tsdoha/utils/shared_preferences.dart';


class MessageSentController extends GetxController {
  final sentedmessage = <MessageSent>[].obs;
  final detailssentmessage = <SendMessage>[].obs;
  final attachmentController = TextEditingController().obs;
  final isLoading = false.obs;
  final isloading = false.obs;

  @override
  void onInit() {
    super.onInit();
    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
      fetchingSentMessage(uid);
    });
  }

  @override
  void onClose() {
    attachmentController.value.dispose();
    super.onClose();
  }

  Future<void> fetchingSentMessage(uid) async {
    isLoading(true);
    final messageList = await ApiServiceMessage.getMessagesSent(uid);
    sentedmessage.assignAll(messageList.reversed);
    isLoading(false);
  }

  Future<void> getsentmessagedetails(int uid, int messageId) async {
    isloading(true);
    final messageList =
        await ApiServiceMessage.getMessagesSentDetails(uid, messageId);
    detailssentmessage.assignAll(messageList);
    isloading(false);
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

  Future<void> convertToBase64(String path) async {
    final file = File(path);
    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);
    final imagePath = base64Image.split(',')[1];
    final selectedImgName = imagePath.split('/').last;
    attachmentController.value.text = selectedImgName;
  }

  Future<void> addCommentWithAttachment(
      String body, int messageId, String attachmentPath, int uid) async {
    isLoading.value = true;
    final String? result = await ApiServiceMessage.addResponse(
      uid,
      body,
      messageId,
      attachmentPath,
    );
    if (result != null) {
      await getsentmessagedetails(uid, messageId);
    } else {
      // Failed to add comment
    }
    isLoading.value = false;
  }
}
