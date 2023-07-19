import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tsdoha/constant/constant.dart';
import 'package:tsdoha/model/auth_model.dart';
import 'package:tsdoha/views/login/login_screen.dart';

class ApiServiceAuth {
  static Future<Object> authenticate(String login, String password) async {
    final url = Uri.parse('${Res.host}/web/session/authenticate');
    final body = jsonEncode({
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "db": "tsdoha",
        "login": login,
        "password": password,
      }
    });
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final auth = Authentificate.fromJson(jsonResponse);

      print(auth);
      print("session_id: ${auth.result!.sessionId}");
      print("uid: ${auth.result!.uid}");
      return Authentificate.fromJson(jsonResponse);
    } else {
      return [];
    }
  }

  static Future<String?> changePassword(
    int parentId,
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    final url = Uri.parse('${Res.host}/web/session/change_password_mobile');
    final body = jsonEncode(
      {
        "jsonrpc": "2.0",
        "method": "call",
        "uid": parentId,
        "params": {
          "old_password": oldPassword,
          "new_password": newPassword,
          "confirm_password": confirmPassword,
        }
      },
    );
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['result']['type'] == 'succes') {
        Get.snackbar(
          'connexion_success_title'.tr,
          'passwordchange'.tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20),
        );
        Get.off(() => LoginScreen());
      } else if (jsonResponse['result']['type'] == 'error') {
        Get.snackbar(
          'connexion_error'.tr,
          'passwordidentical'.tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20),
        );
      }
      return jsonResponse["result"]["res"];
    } else {
      Get.snackbar(
        'connexion_error'.tr,
        'passwordfailedchange'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
      );
    }
    return null;
  }

  static Future<Object> pushData(String pushId, int uid) async {
    final url = Uri.parse('${Res.host}/pushid/set');
    final body = jsonEncode({
      "jsonrpc": "2.0",
      "method": "call",
      "uid": uid,
      "params": {"pushID": pushId}
    });
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse['result']);

      return [];
    } else {
      return [];
    }
  }
  static Future<String?> resetPassword(String email) async {
    final url = Uri.parse('${Res.host}/web/reset_password_json');
    final body = jsonEncode({
      "jsonrpc": "2.0",
      "method": "call",
      "params": {"login": email}
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['result']['success'] == false) {
        Get.snackbar(
          'connexion_success_title'.tr,
          'emailsent'.tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20),
        );
        Get.offAll(() => LoginScreen());
      } else if (jsonResponse['result']['success'] == false) {
        Get.snackbar(
          'error'.tr,
          jsonResponse['result'][0]['responce'].toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20),
        );
      }
      return jsonResponse["result"]["res"];
    } else {
      Get.snackbar(
        'connection_error'.tr,
        'password_failed_change'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
      );
    }
    return null;
  }

}
