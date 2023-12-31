import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tsdoha/constant/constant.dart';
import 'package:tsdoha/controller/message_controller/message_received_controller.dart';
import 'package:tsdoha/main_screen.dart';
import 'package:tsdoha/model/attachement_model.dart';
import 'package:tsdoha/model/comments_model.dart';
import 'package:tsdoha/model/message_model.dart';
import 'package:tsdoha/model/message_sent_model.dart';
import 'package:tsdoha/model/send_message_model.dart';
import 'package:tsdoha/views/home/home_screen.dart';
import 'package:tsdoha/views/mymessages/message_sent_details.dart';


class ApiServiceMessage {

  static final dio = Dio();

  //handle received message
  static Future<List<Message>> getMessagesReceived(int parentId) async {

    final url = '${Res.host}/proschool/parent_message';

    try {
      final response = await dio.post(
        url,
        options: Options(headers: {"Content-Type": "application/json"}),
        data: {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": parentId,
          "params": {"parent_id": parentId, "id": false}
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final parentMessage = jsonResponse['result'][0]['message'];
        List<Message> parentMessages = parentMessage
            .map<Message>((data) => Message.fromJson(data))
            .toList();
        return parentMessages;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  static Future<List<Comment>> getListComments(int uid, int messageId) async {

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
            "model": "proschool.parent.message",
            "res_id": messageId,
            "max_date": false
          }
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final messagedetail = jsonResponse['result'];
        List<Comment> messageData = messagedetail
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
          "params": {"id": [attachmentIds]}
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
        return attachmentData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  static Future<List<Message>> getSingleMessagesReceived(int parentId,int messageId) async {

    final url = '${Res.host}/proschool/parent_message';

    try {
      final response = await dio.post(
        url,
        options: Options(headers: {"Content-Type": "application/json"}),
        data: {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": parentId,
          "params": {"parent_id": parentId, "id": messageId}
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final parentMessage = jsonResponse['result'][0]['message'];
        List<Message> parentMessages = parentMessage
            .map<Message>((data) => Message.fromJson(data))
            .toList();
        return parentMessages;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  //handle received message

  //handle sented message
  static Future<List<SendMessage>> getMessagesSentDetails(uid, int messageId) async {
    final dio = Dio();
    final url = '${Res.host}/proschool/discution_messaging';

    try {
      final response = await dio.post(
        url,
        options: Options(headers: {"Content-Type": "application/json"}),
        data: {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": uid,
          "params": {"id": messageId}
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final messageSentDetails = jsonResponse['result'];
        List<SendMessage> data = messageSentDetails
            .map<SendMessage>(
              (data) => SendMessage.fromJson(data),
        )
            .toList();
        return data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  static Future<List<MessageSent>> getMessagesSent(int parentId) async {
    final dio = Dio();
    final url = '${Res.host}/proschool/liste_messaging';

    try {
      final response = await dio.post(
        url,
        options: Options(headers: {"Content-Type": "application/json"}),
        data: {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": parentId,
          "params": {"uid": parentId}
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final parentMessage = jsonResponse['result'];
        List<MessageSent> parentMessages = parentMessage
            .map<MessageSent>(
              (data) => MessageSent.fromJson(data),
        )
            .toList();
        return parentMessages;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  //handle sented message


  static Future<String?> addComments(
    int uid,
    String? body,
    int messageId,
    String? attachmentPath,
  ) async {
    try {
      final File attachmentFile = File(attachmentPath!);
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
              'model': 'proschool.parent.message',
              'res_id': messageId,
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
          final MessageReceivedController controller = Get.find();
          await controller.getComments(uid, messageId);
          Get.back();
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

  static Future<void> createMessage(
      int parentId,
      String? receiver,
      String? subject,
      String? message,
      String? receiverId,
      String? attachmentPath,
      ) async {
    try {
      final File attachmentFile = File(attachmentPath!);
      final List<int> attachmentBytes = await attachmentFile.readAsBytes();
      final String attachmentBase64 = base64Encode(attachmentBytes);
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
          "attachment": attachmentBase64,
          "name_attachment": attachmentFile.path.split('/').last
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
          final id = jsonResponse['result'][0]['id'];
          try {
            await sendMessage(id);
            return; // Message sent successfully, exit the method
          } catch (e) {
            Get.snackbar(
              'Error',
              'Failed to send the message',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(20),
            );
            return; // Return without throwing an exception
          }
        }
      }
      Get.snackbar(
        'Error',
        'Failed to send the message',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
      );
    }catch (e) {
      print('Exception occurred: $e');
      return null; // Or handle the exception accordingly
    }
  }



  static Future<void> sendMessage(int idMsg) async {
    final url = Uri.parse('${Res.host}/proschool/send_parent_messaging');
    final body = jsonEncode({
      "jsonrpc": "2.0",
      "method": "call",
      "params": {"id": idMsg}
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
      if (jsonResponse['result'] == true) {
        Get.snackbar(
          'connexion_success_title'.tr,
          'messagesent'.tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20),
        );
        //Get.back();
        Get.offAll(() => HomeScreen());
        return; // Message sent successfully, exit the method
      }
    }
    throw Exception('Failed to send the message');
  }

  static Future<String?> addResponse(
      int uid,
      String body,
      int messageId,
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
              'model': 'parent.messaging',
              'res_id': messageId,
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
            'responsesent'.tr,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(20),
          );
          final MessageReceivedController controller = Get.find();
          await controller.getComments(uid, messageId);
          Get.back();
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

  static Future<String?> markAsRead(int uid, int messageId) async {
    final url = Uri.parse('${Res.host}/proschool/message/mark_as_read');
    final body = jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": uid,
          "params": { "ID": messageId }

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
        return jsonResponse["result"].toString();
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
}
