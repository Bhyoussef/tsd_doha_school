import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tsdoha/services/auth.dart';

class PasswordResetController extends GetxController {

  var isLoading = false.obs;
  final resetform = GlobalKey<FormState>();
  final restfield = TextEditingController().obs;


  Future<String?> updatePasswd(String email) async {
    try {
      isLoading(true);
      await ApiServiceAuth.resetPassword(
          email);
    } finally {
      isLoading(false);
    }
    return null;
  }
}
