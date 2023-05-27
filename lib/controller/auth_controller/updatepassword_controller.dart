import 'package:get/get.dart';
import 'package:tunisian_school_doha/services/auth.dart';

import '../../constant/constant.dart';

class PasswordChangeController extends GetxController {
  var isLoading = false.obs;

  updatePasswd(String oldPassword, newPassword, confirmPassword) async {
    try {
      isLoading(true);
      await ApiServiceAuth.changePassword(
          Res.USER!.result!.uid!, oldPassword, newPassword, confirmPassword);
    } finally {
      isLoading(false);
    }
    return null;
  }
}
