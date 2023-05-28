import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/child_model.dart';
import '../../model/comments_model.dart';
import '../../model/message_model.dart';
import '../../services/message.dart';
import '../../services/personal.dart';
import '../../utils/shared_preferences.dart';

class MesaageReceivedController extends GetxController {
  final receivedMessage = <Message>[].obs;
  final childDetail = <Mychildreen>[].obs;
  final comments = <Comment>[].obs;
  final isLoading = true.obs;
  final isLoadingAttachments = false.obs;
  var attachmentControllers = <TextEditingController>[].obs;
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






  void addAttachment() {
    _pickAttachment();
  }

  void removeAttachment(int index) {
    attachmentControllers.removeAt(index);
  }

  Future<void> _pickAttachment() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final attachmentPath = pickedFile.path;
      final attachmentController = TextEditingController(text: attachmentPath);
      attachmentControllers.add(attachmentController);
      attachmentController.addListener(() {
        if (attachmentController.text.isEmpty) {
          removeAttachment(attachmentControllers.indexOf(attachmentController));
        }
      });
    }
  }
}