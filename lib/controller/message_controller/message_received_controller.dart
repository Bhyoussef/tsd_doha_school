import 'package:get/get.dart';
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
  final isLoading = true.obs;



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
      final messageList = await ApiServiceMessage.getMessagesrecieved(uid);
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

  Future<void> getDetailsMessage(uis,int messageId)async{
    try{
      isLoading(true);
      final messagedetail = await ApiServiceMessage.getMessageDetails(6523, messageId);
      messageDetail.assignAll(messagedetail);
      update();
    }finally{
      isLoading(false);
    }
  }

}