import 'package:get/get.dart';
import 'controller/message_controller/message_sent_controller.dart';
import 'controller/message_controller/send_message_controller.dart';
import 'controller/drawer_controller.dart';
import 'controller/home_controller.dart';
import 'controller/language_controller/language_controller.dart';
import 'controller/auth_controller/login_controller.dart';
import 'controller/message_controller/message_received_controller.dart';
import 'controller/mychildren_controller/dowload_file_controller.dart';
import 'controller/mychildren_controller/mychildren_controller.dart';
import 'controller/auth_controller/password_rest_controller.dart';
import 'controller/payment_controller/payments_controller.dart';
import 'controller/auth_controller/updatepassword_controller.dart';

class ControllersBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => PasswordResetController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => DrawerController(), fenix: true);
    Get.lazyPut(() => LanguageController(), fenix: true);
    Get.lazyPut(() => PasswordChangeController(), fenix: true);
    Get.lazyPut(() => ChildrenController(), fenix: true);
    Get.lazyPut(() => MessageReceivedController(), fenix: true);
    Get.lazyPut(() => PaymentsController(), fenix: true);
    Get.lazyPut(() => SendMessageController(), fenix: true);
    Get.lazyPut(() => MesaageSentController(), fenix: true);
    Get.lazyPut(() => FileDownloadController(), fenix: true);
  }
}
