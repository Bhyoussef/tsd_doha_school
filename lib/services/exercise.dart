import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/constant.dart';
import '../controller/exercise/exercise_controller.dart';
import '../model/attachement_model.dart';
import '../model/comments_model.dart';
import 'package:http/http.dart' as http;

class ExerciseApi {
  static final dio = Dio();

  static Future<List<Comment>> getListCommentsExercise(
      int uid, int exerciseId) async {
    final url = '${Res.host}/web/getComment';

    try {
      final response = await dio.post(
        url,
        options: Options(headers: {"Content-Type": "application/json"}),
        data: {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": uid,
          "params": {
            "model": "proschool.homework.student",
            "res_id": exerciseId,
            "max_date": false
          }
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final list = jsonResponse['result'];
        List<Comment> messageData = list
            .map<Comment>(
              (data) => Comment.fromJson(data),
            )
            .toList();
        return messageData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  static Future<List<Attachment>> getAllAttachments(attachmentIds) async {

    final url = '${Res.host}/proschool/get_all_attachment';

    try {
      final response = await dio.post(
        url,
        options: Options(headers: {"Content-Type": "application/json"}),
        data: {
          "jsonrpc": "2.0",
          "method": "call",
          "params": {"id": attachmentIds}
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final attachments = jsonResponse['result'];
        List<Attachment> attachmentData = attachments
            .map<Attachment>(
              (data) => Attachment.fromJson(data),
        )
            .toList();
        print(attachmentData);
        return attachmentData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<String?> addComments(
      int uid,
      String body,
      int commentId,
      String attachmentPath,
      ) async {
    try {
      final File attachmentFile = File(attachmentPath);
      final List<int> attachmentBytes = await attachmentFile.readAsBytes();
      final String attachmentBase64 = base64Encode(attachmentBytes);

      final response = await http.post(
        Uri.parse('${Res.host}/web/commantedPost'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "jsonrpc": "2.0",
            "method": "call",
            "uid": uid,
            "params": {
              'body': body,
              'model': 'proschool.homework.student',
              'res_id': commentId,
              'user_id': uid,
              'attachment': attachmentBase64,
              'name_attachment': attachmentFile.path.split('/').last
            }
          },
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final result = jsonResponse['result'];

        if (result != null) {
          Get.back();
          Get.snackbar(
            'connexion_success_title'.tr,
            'commentadd'.tr,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(20),
          );
          final ExerciseController controller = Get.find();
          await controller.getComments(uid,commentId);
        } else {
          Get.snackbar(
            'error'.tr,
            'Something went wrong',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(20),
          );
        }
        return result.toString();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Exception occurred: $e');
      return null; // Or handle the exception accordingly
    }
  }

  static Future<String?> voteComment(int uid, int messageId) async {
    final url = Uri.parse('${Res.host}/web/toggleVote');
    final body = jsonEncode(
      {
        "jsonrpc": "2.0",
        "method": "call",
        "uid": "6523",
        "params": {"message_id": messageId, "_uid": uid}
      },
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['result'] != null) {
        return jsonResponse["result"].toString(); // Convert the result to a String
      } else if (jsonResponse['result'] == null) {
        return null;
      }
    } else {
      Get.snackbar(
        'error'.tr,
        'Failed To Vote',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
      );
    }

    return null;
  }

  static Future<String?> updatemessagestate(int messageId, int uid) async {
    final url = Uri.parse('${Res.host}/message/mark_as_read');
    final body = jsonEncode(
      {
        "jsonrpc": "2.0",
        "method": "call",
        "uid": uid,
        "params": {
          "ID": messageId
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
      if (jsonResponse['result'] != null) {
      } else if (jsonResponse['result'] == null) {}
      return jsonResponse["result"];
    } else {
      // handle error
    }
    return null;
  }
}
