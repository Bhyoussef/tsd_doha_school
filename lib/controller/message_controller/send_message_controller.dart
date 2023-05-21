import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../constant/constant.dart';
import '../../model/personal_model.dart';
import '../../services/message.dart';
import '../../services/personal.dart';
import '../../utils/shared_preferences.dart';

class SendMessageController extends GetxController {
  var selectedTo = RxString('');
  var selectedRecipient = RxString('');
  var subject = RxString('');
  var message = RxString('');
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

  Future<void> fetchRecipients(uid) async {
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


  Future<String?> sendMessage(
      int parentId,String receiver,
      String subject, String message,String receiverId,) async {

    try {

      isLoading(true);
      await ApiServiceMessage.sendMessage(parentId,
          receiver, subject, message,receiverId);
    } finally {
      isLoading(false);
    }
    return null;
  }

}