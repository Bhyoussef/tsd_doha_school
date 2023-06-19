import 'package:get/get.dart';
import 'package:tsdoha/model/payment_details_model.dart';
import 'package:tsdoha/model/payment_model.dart';
import 'package:tsdoha/services/payment.dart';
import 'package:tsdoha/utils/shared_preferences.dart';


class PaymentsController extends GetxController {
  final paymentsTotalparents = <Payment>[].obs;
  final isloading = false.obs;
  final paymentsTotalstudents = <Payment>[].obs;
  final totalpaiddetailsparents = <PaymentDetails>[].obs;
  final totalinpaiddetailsparents = <PaymentDetails>[].obs;
  final totalpaiddetailsstudents = <PaymentDetails>[].obs;
  final totalinpaiddetailsstudents = <PaymentDetails>[].obs;
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

  Future<void> fetchingTotalPaymentsStudents(int studentId) async {
    isloading(true);
    final paymentList =
        await ApiServicePayment.getPaymentsStudentTotal(studentId);
    paymentsTotalstudents.assignAll(paymentList);
    isloading(false);
  }

  Future<void> fetchingTotalPaymentsStudentsDetail(int studentId) async {
    isloading(true);
    final paymentList =
        await ApiServicePayment.getPaidDetailsStudents(studentId);
    totalpaiddetailsstudents.assignAll(paymentList);
    isloading(false);
  }

  Future<void> fetchingTotalPaymentsParents(uid) async {
    isloading(true);
    final paymentList = await ApiServicePayment.getPaymentsParentTotal(uid);
    paymentsTotalparents.assignAll(paymentList);
    update();
    isloading(false);
  }

  Future<void> fetchingtotalpaiddetailsparents(uid) async {
    isloading(true);
    final paidList = await ApiServicePayment.getPaidDetailsParents(uid);
    totalpaiddetailsparents.assignAll(paidList);
    update();
    isloading(false);
  }

  Future<void> fetchingtotalinpaiddetailsparents(uid) async {
    isloading(true);
    final paidList = await ApiServicePayment.getInPaidDetailsParents(uid);
    totalinpaiddetailsparents.assignAll(paidList);
    update();
    isloading(false);
  }

  Future<void> fetchingTotalInPaidDetailsStudent(int studentId) async {
    isloading(true);
    final paidList =
        await ApiServicePayment.getInPaidDetailsStudents(studentId);
    totalinpaiddetailsstudents.assignAll(paidList);
    update();
    isloading(false);
  }
}
