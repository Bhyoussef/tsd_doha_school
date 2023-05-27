import 'package:get/get.dart';
import 'package:tunisian_school_doha/services/payment.dart';
import '../../model/payment_details_model.dart';
import '../../model/payment_model.dart';
import '../../utils/shared_preferences.dart';

class PaymentsController extends GetxController {
  final paymentsTotalparents = <Payment>[].obs;
  final paymentsTotalstudents = <Payment>[].obs;

  final totalpaiddetailsparents = <PaymentDetails>[].obs;
  final totalinpaiddetailsparents = <PaymentDetails>[].obs;

  final totalpaiddetailsstudents = <PaymentDetails>[].obs;
  final totalinpaiddetailsstudents = <PaymentDetails>[].obs;

  final isLoading = true.obs;

  late int patrentId;

  @override
  void onInit() {
    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
      fetchingTotalPaymentsParents(uid);
      fetchingtotalpaiddetailsparents(uid);
      fetchingtotalinpaiddetailsparents(uid);
    });
    super.onInit();
  }

  fetchingTotalPaymentsStudents(int studentId) async {
    try {
      isLoading(true);
      final paymentList =
          await ApiServicePayment.getPaymentsStudentTotal(studentId);
      paymentsTotalstudents.assignAll(paymentList);
      update();
    } finally {
      isLoading(false);
    }
  }

  fetchingTotalPaymentsStudentsDetail(int studentId) async {
    try {
      isLoading(true);
      final paymentList =
          await ApiServicePayment.getPaidDetailsStudents(studentId);
      totalpaiddetailsstudents.assignAll(paymentList);
      update();
    } finally {
      isLoading(false);
    }
  }

  fetchingTotalPaymentsParents(uid) async {
    try {
      isLoading(true);
      final paymentList = await ApiServicePayment.getPaymentsParentTotal(uid);
      paymentsTotalparents.assignAll(paymentList);
      update();
    } finally {
      isLoading(false);
    }
  }

  fetchingtotalpaiddetailsparents(uid) async {
    try {
      isLoading(true);
      final paidList = await ApiServicePayment.getPaidDetailsParents(uid);
      totalpaiddetailsparents.assignAll(paidList);
      update();
    } finally {
      isLoading(false);
    }
  }

  fetchingtotalinpaiddetailsparents(uid) async {
    try {
      isLoading(true);
      final paidList = await ApiServicePayment.getInPaidDetailsParents(uid);
      totalinpaiddetailsparents.assignAll(paidList);
      update();
    } finally {
      isLoading(false);
    }
  }

  fetchingTotalInPaidDetailsStudent(int studentId) async {
    try {
      isLoading(true);
      final paidList =
          await ApiServicePayment.getInPaidDetailsStudents(studentId);
      totalinpaiddetailsstudents.assignAll(paidList);
      update();
    } finally {
      isLoading(false);
    }
  }
}
