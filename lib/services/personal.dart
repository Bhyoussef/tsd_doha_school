import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tsdoha/model/child_model.dart';
import '../constant/constant.dart';
import '../model/personal_model.dart';

class ApiServicePersonal {
  static Future<List<Personal>> getPersonal(int uid, String type) async {
    final response = await http.post(
      Uri.parse('${Res.host}/proschool/liste_teacher'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "params": {
            "id": type,
            "class_ids": "",
            "parent_id": uid,
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final personalList = jsonResponse['result'];
      List<Personal> personalListData = personalList
          .map<Personal>(
            (data) => Personal.fromJson(data),
          )
          .toList();
      return personalListData;
    } else {
      throw Exception('Failed to load data');
    }
  }
  static Future<List<Mychildreen>> getSingleChild(int parentId, int studentId) async {
    final response = await http.post(
      Uri.parse('${Res.host}/proschool/child'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": parentId,
          "params": {
            "parent_id": parentId ,
            "id": studentId
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final child = jsonResponse['result'][0]['childrens'];
      List<Mychildreen> childdata = child
          .map<Mychildreen>(
            (data) => Mychildreen.fromJson(data),
      )
          .toList();
      return childdata;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
