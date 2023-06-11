import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/comments_model.dart';
import '../../services/exercise.dart';
import '../../utils/shared_preferences.dart';

class ExerciseController extends GetxController {
  final comments = <Comment>[].obs;
  final isLoading = false.obs;
  bool isloading = true;
  final attachmentController = TextEditingController().obs;

  final isLoadingAttachments = false.obs;

  int? parentId;

  @override
  void onInit() {
    super.onInit();
    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {});
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getComments(int uid, int exerciseId) async {
    isLoading.value = true;
    try {
      final commentsList =
          await ExerciseApi.getListCommentsExercise(uid, exerciseId);
      comments.assignAll(commentsList);
      for (var comment in commentsList) {
        if (comment.attachmentIds!.isNotEmpty) {
          isLoadingAttachments(true);
          final attachments =
          await ExerciseApi.getAllAttachments(comment.attachmentIds);
          comment.attachments = attachments;
          isLoadingAttachments(false);
          print(attachments);
        }
      }
    } catch (e) {
      print('Failed to fetch comments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> voteComment(int uid, int messageId) async {
    try {
      await ExerciseApi.voteComment(
        uid,
        messageId,
      );
    } finally {}
    return null;
  }

  Future<String?> updateMessageState(int uid, int messageId) async {
    try {
      isLoading(true);
      await ExerciseApi.updatemessagestate(uid, messageId);
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
      String body, int exerciseId, String attachmentPath, int uid) async {
    try {
      isLoading.value = true;
      final String? result = await ExerciseApi.addComments(
        uid,
        body,
        exerciseId,
        attachmentPath,
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
