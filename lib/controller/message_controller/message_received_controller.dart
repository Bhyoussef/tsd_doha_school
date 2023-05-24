import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/child_model.dart';
import '../../model/message_detail.dart';
import '../../model/message_model.dart';
import '../../services/message.dart';
import '../../services/personal.dart';
import '../../utils/shared_preferences.dart';


class MesaageReceivedController extends GetxController {
  final receivedmessage = <Message>[].obs;
  final childdetail = <Mychildreen>[].obs;
  final messageDetail = <MessageDetail>[].obs;
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

  Future<void> getDetailsMessage(uid,int messageId)async{
    try{
      isLoading(true);
      final messagedetail = await ApiServiceMessage.getMessageDetails(6523, messageId);
      messageDetail.assignAll(messagedetail);
      update();
    }finally{
      isLoading(false);
    }
  }

  Future<void> updateMessageState(uid,int messageId)async{
    try{
      isLoading(true);
      final updatemessage = await ApiServiceMessage.getMessageDetails(6523, messageId);
      messageDetail.assignAll(updatemessage);
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
        // Remove attachment controller if the text is empty (attachment is cleared)
        if (attachmentController.text.isEmpty) {
          removeAttachment(attachmentControllers.indexOf(attachmentController));
        }
      });
    }
  }
}