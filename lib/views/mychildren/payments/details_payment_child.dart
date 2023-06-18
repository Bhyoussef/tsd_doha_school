import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/constant.dart';
import '../../../controller/payment_controller/payments_controller.dart';
import '../../../model/child_model.dart';
import '../../../routes/routes.dart';
import '../../../theme/app_colors.dart';
import '../../mypayments/widget/child_payment_card_widget.dart';
import '../widget/payment_list_widget_child.dart';

class DetailsPaymentChild extends StatefulWidget {
  final int? studentId;
  final Mychildreen? student;
  const DetailsPaymentChild({Key? key, this.studentId, this.student})
      : super(key: key);

  @override
  State<DetailsPaymentChild> createState() => _DetailsPaymentChildState();
}

class _DetailsPaymentChildState extends State<DetailsPaymentChild> {
  final PaymentsController paymentController = Get.find<PaymentsController>();
  bool isLoading = true; // Add isLoading variable

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData(); // Move the fetching logic to a separate function
    });
  }

  Future<void> fetchData() async {
    await paymentController
        .fetchingTotalPaymentsStudents(widget.student!.studentId!);
    setState(() {
      isLoading = false; // Update isLoading to false when data is received
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: CupertinoColors.white),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primarycolor,
        title: Text(
          'mypayments'.tr,
          style: const TextStyle(
              color: CupertinoColors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(Routes.home);
              },
              child: Image.asset(
                'assets/imgs/tsdIcon.png',
                width: 40,
                height: 40,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading // Check isLoading value
            ? Center(
          child: CircularProgressBar(
            color: primarycolor,
          ),
        )
            : Obx(() {
          if (paymentController.paymentsTotalstudents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/imgs/notfound.png'),
                  Text('nopaymentshistoryfound'.tr),
                ],
              ),
            );
          } else {
            return ListView(
              children: [
                ChildCardPayment(student: widget.student!),
                const SizedBox(height: 15),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: paymentController.paymentsTotalstudents.length,
                  itemBuilder: (context, index) {
                    final paymentTotal =
                    paymentController.paymentsTotalstudents[index];
                    return PaymentChildListItem(
                      paymentTotal: paymentTotal,
                      student: widget.student!,
                    );
                  },
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}

