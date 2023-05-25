import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/attachement_model.dart';
import '../../model/child_model.dart';
import '../../model/message_detail.dart';
import '../../model/message_model.dart';
import '../../services/message.dart';
import '../../services/personal.dart';
import '../../utils/shared_preferences.dart';


class MesaageReceivedController extends GetxController {
  final receivedmessage = <Message>[].obs;
  final childdetail = <Mychildreen>[].obs;
  final comments = <MessageDetail>[].obs;
  final allattachements = <Attachment>[].obs;
  var attachmentControllers = <TextEditingController>[].obs;
  final isLoading = true.obs;
  int? parentId;


  @override
  void onInit() {
    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
      fetchingReceivedMessage(uid);
    });
    super.onInit();

  }

  Future<void> fetchingReceivedMessage(uid) async {
    try {
      isLoading(true);
      final messageList = await ApiServiceMessage.getMessagesrecieved(uid!);
      receivedmessage.assignAll(messageList);
      update();
    } finally {
      isLoading(false);
    }
  }

  Future<void> getChildDetail(uid,int studentId) async {
    try {
      isLoading(true);
      final childdetail = await ApiServicePersonal.getSingleChild(uid, studentId);
      childdetail.assignAll(childdetail);
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
      for (MessageDetail comment in commentsList) {
        if (comment.attachmentIds!.isNotEmpty) {
          await getAllAttachments(comment.attachmentIds);
          comment.attachments = allattachements.toList() as List<Attachment>?;
        }
      }
      update();
    } finally {
      isLoading(false);
    }
  }



  Future<void> updateMessageState(uid,int messageId)async{
    try{
      isLoading(true);
      final updatemessage = await ApiServiceMessage.getListComments(6523, messageId);
      comments.assignAll(updatemessage);
      update();
    }finally{
      isLoading(false);
    }
  }

  Future<void> addComments(uid,String body,int studentId)async{
    try{
      isLoading(true);
        await ApiServiceMessage.addComments(uid,  body, studentId);
        update();
    }finally{
      isLoading(false);
    }
  }

  Future<void> getAllAttachments(List<int>? attachmentIds) async {
    if (attachmentIds == null || attachmentIds.isEmpty) {
      return;
    }
    try {
      isLoading(true);
      final attachmentsData =
      await ApiServiceMessage.getAllattachements(attachmentIds);
      allattachements.assignAll(attachmentsData);
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