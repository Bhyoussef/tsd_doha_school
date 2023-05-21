import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../model/message_sent_model.dart';
import '../../services/message.dart';
import '../../utils/shared_preferences.dart';

class MesaageSentController extends GetxController {
  final sentedmessage = <MessageSent>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
      fetchingSentMessage(uid);
    });
    super.onInit();
  }

  Future<void> fetchingSentMessage(uid) async {
    try {
      isLoading(true);
      final messageList =
          await ApiServiceMessage.getMessagesSented(uid);
      sentedmessage.assignAll(messageList);
      update();
    } finally {
      isLoading(false);
    }
  }
}
