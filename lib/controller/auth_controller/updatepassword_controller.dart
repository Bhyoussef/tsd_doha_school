import 'package:get/get.dart';
import '../../services/auth.dart';

class PasswordChangeController extends GetxController {
  var isLoading = false.obs;



  Future<String?> updatePasswd(
      String oldPassword, newPassword, confirmPassword) async {
    try {
      isLoading(true);
      await ApiServiceAuth.changePassword(
          6523, oldPassword, newPassword, confirmPassword);
    } finally {
      isLoading(false);
    }
    return null;
  }
}
