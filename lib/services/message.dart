import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constant/constant.dart';
import '../model/attachement_model.dart';
import '../model/message_detail.dart';
import '../model/message_model.dart';
import '../model/message_sent_model.dart';
import '../model/send_message_model.dart';
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
  static Future<List<SendMessage>> getMessagesSentedDeatails(uid ,int messageId) async {
    final response = await http.post(
      Uri.parse('${Res.host}/proschool/discution_messaging'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": "6523",
          "params": {
            "id": messageId
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final messagesentdetails = jsonResponse['result'];
      List<SendMessage> data = messagesentdetails
          .map<SendMessage>(
            (data) => SendMessage.fromJson(data),
      )
          .toList();
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<String?> sendMessage(
    int parentId,
    String receiver,
    String subject,
    String message,
    String receiverId, String attachmentPath,
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
        "attachment": attachmentPath,
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

  static Future<List<MessageDetail>> getListComments(
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

  static Future<String?> addComments(int uid ,String body,int studentId) async {
    final response = await http.post(
      Uri.parse('${Res.host}/web/commantedPost'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": 6523,
          "params": {
            "body": "body",
            "model": "proschool.parent.message",
            "res_id": 48812,
            "user_id": 6523,
            "attachment": null,
            "name_attachment": null
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['result'] != null) {
        Get.snackbar(
          'Success :',
          'Your comment have been succsufully added ',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20),
        );

      } else if (jsonResponse['result'] == null) {
        Get.snackbar(
          'Error :',
          'Something wrong happened ',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20),
        );
      }
      return jsonResponse["result"];
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<Attachment>> getAllattachements(attachmentIds) async {
    final response = await http.post(
      Uri.parse('${Res.host}/proschool/get_all_attachment'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "params": {
            "id":attachmentIds
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final attachements = jsonResponse['result'];
      List<Attachment> attachememntdata = attachements.map<Attachment>(
            (data) => Attachment.fromJson(data),).toList();
      print(attachememntdata);
      return attachememntdata;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
