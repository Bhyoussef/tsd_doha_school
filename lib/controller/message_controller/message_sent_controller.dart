import 'package:get/get.dart';
import 'package:tunisian_school_doha/model/send_message_model.dart';

import '../../model/message_sent_model.dart';
import '../../services/message.dart';
import '../../utils/shared_preferences.dart';

class MesaageSentController extends GetxController {
  final sentedmessage = <MessageSent>[].obs;
  final detailssentmessage = <SendMessage>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
      fetchingSentMessage(uid);
    });
    super.onInit();
  }

  fetchingSentMessage(uid) async {
    try {
      isLoading(true);
      final messageList = await ApiServiceMessage.getMessagesSented(uid);
      sentedmessage.assignAll(messageList);
      update();
    } finally {
      isLoading(false);
    }
  }

  getsentmessagedetails(uid, int messageId) async {
    try {
      isLoading(true);
      final messageList =
          await ApiServiceMessage.getMessagesSentedDeatails(uid, messageId);
      detailssentmessage.assignAll(messageList);
      update();
    } finally {
      isLoading(false);
    }
  }
}
