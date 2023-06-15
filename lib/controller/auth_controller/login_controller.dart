import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/model/auth_model.dart';
import 'package:tsdoha/routes/routes.dart';
import 'package:tsdoha/services/auth.dart';
import 'package:tsdoha/utils/shared_preferences.dart';
import 'package:tsdoha/views/home/home_screen.dart';


class AuthController extends GetxController {
  var isLoading = false.obs;
  final loginFormKey = GlobalKey<FormState>();
  final loginController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  void authenticateUser(String login, String password) async {
    try {
      isLoading(true);
      final result = await ApiServiceAuth.authenticate(login, password);
      if (result is Authentificate) {
        if (kDebugMode) {
          print(jsonEncode(result.result));
        }
        SharedData.saveToStorage('parent', jsonEncode(result.result), 'string');
        Get.snackbar(
          'connexion_success_title'.tr,
          'connexion_success_text'.tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20),
        );
        Get.off(() => HomeScreen(),
            transition: Transition.circularReveal,
            duration: const Duration(seconds: 2));
      }
    } catch (e) {
      Get.snackbar(
        'connexion_error'.tr,
        'please_verify_your_information'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
      );
    } finally {
      isLoading(false);
    }
  }

  void logout() async {
    SharedData.logout();
    SharedData.clearStorage();
    Get.offAllNamed(Routes.getSpalsh());
  }
}
