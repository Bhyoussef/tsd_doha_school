import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constant/constant.dart';
import '../controller/message_controller/message_received_controller.dart';
import '../model/attachement_model.dart';
import '../model/comments_model.dart';
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

  static Future<List<SendMessage>> getMessagesSentedDeatails(
      uid, int messageId) async {
    final response = await http.post(
      Uri.parse('${Res.host}/proschool/discution_messaging'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": uid,
          "params": {"id": messageId}
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

  static Future<void> createMessage(
      int parentId,
      String receiver,
      String subject,
      String message,
      String receiverId,
      String attachmentPath,
      ) async {
     try {
       final File attachmentFile = File(attachmentPath);
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
        Get.to(() => HomeScreen());
        return; // Message sent successfully, exit the method
      }
    }
    throw Exception('Failed to send the message');
  }



  static Future<List<Comment>> getListComments(int uid, int messageId) async {
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
      List<Comment> messageData = messagedetail
          .map<Comment>(
            (data) => Comment.fromJson(data),
          )
          .toList();
      return messageData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<String?> addComments(
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

  static Future<List<Attachment>> getAllattachements(attachmentIds) async {
    final response = await http.post(
      Uri.parse('${Res.host}/proschool/get_all_attachment'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "params": {"id": attachmentIds}
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final attachements = jsonResponse['result'];
      List<Attachment> attachememntdata = attachements
          .map<Attachment>(
            (data) => Attachment.fromJson(data),
          )
          .toList();
      print(attachememntdata);
      return attachememntdata;
    } else {
      throw Exception('Failed to load data');
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
