import 'package:get/get.dart';
import '../../services/auth.dart';

class PasswordChangeController extends GetxController {
  var isLoading = false.obs;



  Future<String?> updatePasswd(int uid,
      String oldPassword, newPassword, confirmPassword) async {
    try {
      isLoading(true);
      await ApiServiceAuth.changePassword(
          uid, oldPassword, newPassword, confirmPassword);
    } finally {
      isLoading(false);
    }
    return null;
  }
}
