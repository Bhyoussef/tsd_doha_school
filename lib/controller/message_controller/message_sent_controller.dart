import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsdoha/model/send_message_model.dart';
import 'package:tsdoha/model/message_sent_model.dart';
import 'package:tsdoha/services/message.dart';

class MessageSentController extends GetxController {
  final sentedmessage = <MessageSent>[].obs;
  final detailssentmessage = <SendMessage>[].obs;
  final attachmentController = TextEditingController().obs;
  final isLoading = false.obs;


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    attachmentController.value.dispose();
    super.onClose();
  }

  Future<void> fetchingSentMessage(int uid) async {
    try {
      isLoading(true);
      final messageList = await ApiServiceMessage.getMessagesSented(uid);
      sentedmessage.assignAll(messageList.reversed);
    } catch (error) {
      // Handle error
    } finally {
      isLoading(false);
    }
  }

  Future<void> getsentmessagedetails(int uid, int messageId) async {
    try {
      isLoading(true);
      final messageList =
      await ApiServiceMessage.getMessagesSentedDeatails(uid, messageId);
      detailssentmessage.assignAll(messageList);
    } finally {
      isLoading(false);
    }
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
    try {
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
    } catch (error) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }
}
