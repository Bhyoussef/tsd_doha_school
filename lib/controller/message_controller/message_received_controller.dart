import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import '../../model/child_model.dart';
import '../../model/comments_model.dart';
import '../../model/message_model.dart';
import '../../services/message.dart';
import '../../services/personal.dart';
import '../../utils/shared_preferences.dart';

class MessageReceivedController extends GetxController {
  final receivedMessage = <Message>[].obs;
  final childDetail = <Mychildreen>[].obs;
  final comments = <Comment>[].obs;
  final isLoading = true.obs;
  final isLoadingAttachments = false.obs;
  final attachmentController = TextEditingController().obs;
  int? parentId;

  @override
  void onInit() {
    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
      await fetchReceivedMessage(uid);
    });
    super.onInit();
  }

  Future<void> fetchReceivedMessage(uid) async {
    try {
      isLoading(true);
      final messageList = await ApiServiceMessage.getMessagesrecieved(uid!);
      receivedMessage.assignAll(messageList);
      update();
    } finally {
      isLoading(false);
    }
  }

  Future<void> getChildDetail(uid, int studentId) async {
    try {
      isLoading(true);
      final childDetail =
          await ApiServicePersonal.getSingleChild(uid, studentId);
      this.childDetail.assignAll(childDetail);
      update();
    } finally {
      isLoading(false);
    }
  }

  Future<void> getComments(uid, int messageId) async {
    try {
      isLoading(true);
      final commentsList =
          await ApiServiceMessage.getListComments(uid, messageId);
      comments.assignAll(commentsList);
      // Check if comments have attachment IDs and fetch attachments if available
      for (var comment in commentsList) {
        if (comment.attachmentIds!.isNotEmpty) {
          isLoading(true);
          final attachments =
              await ApiServiceMessage.getAllattachements(comment.attachmentIds);
          comment.attachments = attachments;
          isLoading(false);
        }
      }
      update();
    } finally {
      isLoading(false);
    }
  }

  Future<String?> voteComment(int uid, int messageId) async {
    try {
      await ApiServiceMessage.voteComment(
        uid,
        messageId,
      );
    } finally {
    }
    return null;
  }

  Future<String?> updateMessageState(int  uid,int messageId) async {
    try {
      isLoading(true);
      await ApiServiceMessage.updatemessagestate(uid,messageId);
      // You can handle the response or update the comments list accordingly
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

  Future<void> addCommentWithAttachment(
      String body, int messageId, String attachmentPath, int uid) async {
    try {
      isLoading.value = true;
      final String? result = await ApiServiceMessage.addComments(
        uid,
        body,
        messageId,
        attachmentPath,
      );
      if (result != null) {
        //Get.back();
        // Refresh comments
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
