import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/auth_model.dart';
import '../../routes/routes.dart';
import '../../services/auth.dart';
import '../../utils/shared_preferences.dart';
import '../../views/home/home_screen.dart';
import '../../views/onbording/spalsh_screen.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  void authenticateUser(String login, String password) async {
    try {
      isLoading(true);
      final result = await ApiServiceAuth.authenticate(login, password);

      if (result is Authentificate) {
        print(jsonEncode(result.result));

        SharedData.saveToStorage('parent', jsonEncode(result.result), 'string');
        Get.snackbar(
          'connexion_success_title'.tr,
          'connexion_success_text'.tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20),
        );
        Get.off(() => HomeScreen());
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
    SharedData.clearStorage();
    SharedData.logout();
    Get.toNamed(Routes.getspalsh());
  }
}
