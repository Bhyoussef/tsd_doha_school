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
      final childDetail = await ApiServicePersonal.getSingleChild(uid, studentId);
      this.childDetail.assignAll(childDetail);
      update();
    } finally {
      isLoading(false);
    }
  }

  Future<void> getComments(uid, int messageId) async {
    try {
      isLoading(true);
      final commentsList = await ApiServiceMessage.getListComments(6523, messageId);
      comments.assignAll(commentsList);
      // Check if comments have attachment IDs and fetch attachments if available
      for (var comment in commentsList) {
        if (comment.attachmentIds!.isNotEmpty) {
          isLoading(true);
          final attachments = await ApiServiceMessage.getAllattachements(comment.attachmentIds);
          comment.attachments = attachments;
          isLoading(false);
        }
      }
      update();
    } finally {
      isLoading(false);
    }
  }

  Future<String?> voteComment(int messageId) async {
    try {
      isLoading(true);
      await ApiServiceMessage.voteComment(
        6523, // Assuming parentId is already assigned in the controller
        messageId,
      );
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


  Future<String?> addComment(
      int uid, String body, String studentId,String attachementPath
      ) async {
    try {
      isLoading(true);
      await ApiServiceMessage.addComments(
        uid,
        body,
        studentId,
        attachementPath,
      );
    } finally {
      isLoading(false);
    }
    return null;
  }


}
