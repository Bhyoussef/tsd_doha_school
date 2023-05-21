import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;
import '../constant/constant.dart';
import '../model/message_detail.dart';
import '../model/message_model.dart';
import '../model/message_sent_model.dart';
import '../views/home/home_screen.dart';

class ApiServiceMessage {
  static Future<List<Message>> getMessagesrecieved(int parentId) async {
    final response = await http.post(
      Uri.parse('${Res.host}/proschool/parent_message'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": parentId,
          "params": {"parent_id": parentId, "id": false}
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final parentMessage = jsonResponse['result'][0]['message'];
      List<Message> parentmessages =
          parentMessage.map<Message>((data) => Message.fromJson(data)).toList();
      return parentmessages;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<MessageSent>> getMessagesSented(int parentId) async {
    final response = await http.post(
      Uri.parse('${Res.host}/proschool/liste_messaging'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": parentId,
          "params": {"uid": parentId}
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final parentMessage = jsonResponse['result'];
      List<MessageSent> parentmessages = parentMessage
          .map<MessageSent>(
            (data) => MessageSent.fromJson(data),
          )
          .toList();
      return parentmessages;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<String?> sendMessage(
    int parentId,
    String receiver,
    String subject,
    String message,
    String receiverId,
  ) async {
    final url = Uri.parse('${Res.host}/proschool/send_teacher_messaging');
    final body = jsonEncode({
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "receiver": receiver,
        "id": receiverId,
        "uid": parentId,
        "subject": subject,
        "message": message,
        "attachment": "",
        "name_attachment": ""
      }
    });
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['result'][0]['Resultat'] == 'True') {
        Get.snackbar(
          'Success :',
          'Your message has been sent successfully ',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20),
        );
        Get.to(() => HomeScreen());
      } else if (jsonResponse['result'][0]['Resultat'] == 'False') {
        Get.snackbar(
          'Error :',
          'Failed to send your message ',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20),
        );
      }
    }
    return null;
  }

  static Future<List<MessageDetail>> getMessageDetails(
      int uid, int messageId) async {
    final response = await http.post(
      Uri.parse('${Res.host}/web/getComment'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": uid,
          "params": {
            "model": "proschool.parent.message",
            "res_id": messageId,
            "max_date": false
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final messagedetail = jsonResponse['result'];
      List<MessageDetail> messageData = messagedetail
          .map<MessageDetail>(
            (data) => MessageDetail.fromJson(data),
          )
          .toList();
      return messageData;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
