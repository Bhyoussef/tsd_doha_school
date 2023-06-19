import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsdoha/model/attachement_model.dart';
import 'package:tsdoha/model/child_model.dart';
import 'package:tsdoha/model/comments_model.dart';
import 'package:tsdoha/model/message_model.dart';
import 'package:tsdoha/services/message.dart';
import 'package:tsdoha/utils/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';

class MessageReceivedController extends GetxController {
  final childDetail = <Mychildreen>[].obs;
  RxList<Message> receivedMessage = RxList();
  final comments = <Comment>[].obs;
  final isLoading = false.obs;
  final isloading = false.obs;
  final attachments = <Attachment>[].obs;
  final isLoadingAttachments = false.obs;
  final attachmentController = TextEditingController().obs;
  int? parentId;


  @override
  void onInit() {
    super.onInit();
    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
      fetchReceivedMessage(uid);
    });

  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void>fetchReceivedMessage(uid) async {
      isLoading(true);
      final list = await ApiServiceMessage.getMessagesReceived(uid);
      receivedMessage.assignAll(list);
      isLoading(false);
  }

  Future<void> getComments(int uid, int messageId) async {
    isloading.value = true;
    try {
      final commentsList = await ApiServiceMessage.getListComments(uid, messageId);
      comments.assignAll(commentsList);
      for (var comment in commentsList) {
        getAttachements(comment.attachmentIds, comment.id);
      }
    } catch (e) {
      print('Failed to fetch comments: $e');
    } finally {
      isloading.value = false;
    }
  }

  Future<String?> getAttachements(attachements, msgId) async {
    for (var att in attachements ) {
      if (att != null) {
        final attachments = await ApiServiceMessage.getAllAttachments(att);
        var comment = comments.where((c) => c.id == msgId);
        comment.first.attachments = attachments;
        print('Comment ===== ${comment.first}');
        comments.refresh();
      }
    }
    return null;
  }



  Future<String?> voteComment(int uid, int messageId) async {
    try {
      await ApiServiceMessage.voteComment(
        uid,
        messageId,
      );
    } finally {}
    return null;
  }
  Future<String?> markAsRead(int uid, int messageId) async {
    try {
      await ApiServiceMessage.markAsRead(
        uid,
        messageId,
      );
    } finally {}
    return null;
  }

  Future<String?> updateMessageState(int uid, int messageId) async {
    try {
      isLoading(true);
      await ApiServiceMessage.updatemessagestate(uid, messageId);
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
      String? body, int messageId, String? attachmentPath, int uid) async {
    try {
      isLoading.value = true;
      final String? result = await ApiServiceMessage.addComments(
        uid,
        body!,
        messageId,
        attachmentPath!,
      );
      if (result != null) {
        // Handle success
      } else {
        // Handle failure
      }
    } catch (error) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }
}
