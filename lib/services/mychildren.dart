import 'dart:convert';
import '../constant/constant.dart';
import 'package:http/http.dart' as http;
import '../model/book_model.dart';
import '../model/child_model.dart';
import '../model/exersice_model.dart';
import '../model/time_table_model.dart';

class ApiServiceMyChildren {
  static Future<List<Mychildreen>> getChildren(int parentId) async {
    final response = await http.post(
      Uri.parse('${Res.host}/proschool/child'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": parentId,
          "params": {
            "parent_id": parentId,
            "id": false,
          }
        },
      ),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final childrenJson = json['result'][0]['childrens'];
      List<Mychildreen> children = childrenJson
          .map<Mychildreen>(
            (data) => Mychildreen.fromJson(data),
          )
          .toList();
      return children;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<Book>> fetchBooks(
    int studentId,
  ) async {
    final response = await http.post(
      Uri.parse('${Res.host}/proschool/giveme_note'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": false,
          "params": {
            "student_id": studentId,
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final bookData = jsonData['result'];
      List<Book> booksList = bookData
          .map<Book>(
            (data) => Book.fromJson(data),
          )
          .toList();
      return booksList;
    } else {
      throw Exception('Failed to fetch books');
    }
  }

  static Future<List<Exersice>> fetchExercise(
    int studentId,
  ) async {
    final response = await http.post(
      Uri.parse('${Res.host}/proschool/homework/student'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "uid": false,
          "method": "call",
          "params": {
            "child_id": studentId,
            "id": false,
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final bookData = jsonData['result'][0]["homework_student"];
      /* List<Exersice> exerciseList = bookData
          .map<Exersice>((data) => Exersice.fromJson(data))
          .toList();*/
      return [];
    } else {
      throw Exception('Failed to fetch books');
    }
  }

  static Future<List<TimeTable>> fetchTimeTable(int studentId,String ClassId) async {
    final response = await http.post(
      Uri.parse('${Res.host}/proschool/giveme_all_calendar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": false,
          "params": {
            "class_id": ClassId,
            "choice": "thisweek",
            "student_id": studentId,
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final bookData = jsonData['result'][0]["calendar"];
       List<TimeTable> timetableList = bookData
          .map<TimeTable>((data) => TimeTable.fromJson(data))
          .toList();
      return timetableList;
    } else {
      throw Exception('Failed to fetch books');
    }
  }
}
