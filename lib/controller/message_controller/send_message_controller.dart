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
  var attachmentControllers = <TextEditingController>[].obs; // Updated list type
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
      List<String> attachmentPaths,
      ) async {
    try {
      isLoading(true);
      await ApiServiceMessage.createMessage(
        parentId,
        receiver,
        subject,
        message,
        receiverId,
        attachmentPaths as String,
      );
    } finally {
      isLoading(false);
    }
    return null;
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
  }}