import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tsdoha/services/auth.dart';

class PasswordResetController extends GetxController {

  var isLoading = false.obs;
  final resetform = GlobalKey<FormState>();
  final restfield = TextEditingController().obs;


  Future<String?> updatePasswd(String uid) async {
    try {
      isLoading(true);
      await ApiServiceAuth.resetPassword(
          uid);
    } finally {
      isLoading(false);
    }
    return null;
  }
}
