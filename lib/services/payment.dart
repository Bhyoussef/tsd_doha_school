import 'dart:convert';
import '../constant/constant.dart';
import 'package:http/http.dart' as http;
import '../model/payment_details_model.dart';
import '../model/payment_model.dart';

class ApiServicePayment {
  static Future<List<Payment>> getPaymentsParentTotal(int uid) async {
    final response = await http.post(
      Uri.parse('${Res.host}/proschool/give_me_total'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": uid,
          "params": {
            "parent_id": uid,
            "student_id": false,
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final paymenttotal = jsonResponse['result'];
      List<Payment> payemntsTotal = paymenttotal
          .map<Payment>(
            (data) => Payment.fromJson(data),
          )
          .toList();
      return payemntsTotal;
    } else {
      throw Exception('Failed to load data');
    }
  }
  static Future<List<Payment>> getPaymentsStudentTotal(int studentId) async {
    final response = await http.post(
      Uri.parse('${Res.host}/proschool/give_me_total'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": "",
          "params": {
            "parent_id": false,
            "student_id": studentId,
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final paymenttotal = jsonResponse['result'];
      List<Payment> payemntsTotal = paymenttotal
          .map<Payment>(
            (data) => Payment.fromJson(data),
      )
          .toList();
      return payemntsTotal;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<PaymentDetails>> getPaidDetails(int studentId,
  ) async {
    final response = await http.post(
      Uri.parse('${Res.host}/proschool/give_me_total_paid'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": false,
          "params": {
            "student_id": studentId,
            "parent_id": false,
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final paiddetails = jsonResponse['result'];
      List<PaymentDetails> paidDetails = paiddetails
          .map<PaymentDetails>(
            (data) => PaymentDetails.fromJson(data),
          )
          .toList();
      return paidDetails;
    } else {
      throw Exception('Failed to load data');
    }
  }
  static Future<List<PaymentDetails>> getPaidDetailsStudents(int studentId,
      ) async {
    final response = await http.post(
      Uri.parse('${Res.host}/proschool/give_me_total_paid'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": false,
          "params": {
            "student_id": studentId,
            "parent_id": false,
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final paiddetails = jsonResponse['result'];
      List<PaymentDetails> paidDetails = paiddetails
          .map<PaymentDetails>(
            (data) => PaymentDetails.fromJson(data),
      )
          .toList();
      return paidDetails;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<PaymentDetails>> getInPaidDetailsStudents(int studentId,
      ) async {
    final response = await http.post(
      Uri.parse('${Res.host}/proschool/give_me_total_unpaid'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": false,
          "params": {
            "student_id": studentId,
            "parent_id": false,
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final paiddetails = jsonResponse['result'];
      List<PaymentDetails> paidDetails = paiddetails
          .map<PaymentDetails>(
            (data) => PaymentDetails.fromJson(data),
      )
          .toList();
      return paidDetails;
    } else {
      throw Exception('Failed to load data');
    }
  }




  static Future<List<PaymentDetails>> getPaidDetailsParents(int parentId,
      ) async {
    final response = await http.post(
      Uri.parse('${Res.host}/proschool/give_me_total_paid'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": false,
          "params": {
            "student_id": false,
            "parent_id": parentId,
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final paiddetails = jsonResponse['result'];
      List<PaymentDetails> paidDetails = paiddetails
          .map<PaymentDetails>(
            (data) => PaymentDetails.fromJson(data),
      )
          .toList();
      return paidDetails;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<PaymentDetails>> getInPaidDetailsParents(int parentId,
      ) async {
    final response = await http.post(
      Uri.parse('${Res.host}/proschool/give_me_total_unpaid'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "jsonrpc": "2.0",
          "method": "call",
          "uid": parentId,
          "params": {
            "student_id": false,
            "parent_id": parentId,
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final inpaiddetails = jsonResponse['result'];
      List<PaymentDetails> InpaidDetails = inpaiddetails
          .map<PaymentDetails>(
            (data) => PaymentDetails.fromJson(data),
      )
          .toList();
      return InpaidDetails;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
