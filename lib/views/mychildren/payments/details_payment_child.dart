import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/constant.dart';
import '../../../controller/payment_controller/payments_controller.dart';
import '../../../model/child_model.dart';
import '../../../model/payment_details_model.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/shared_preferences.dart';
import '../../mypayments/payment_screen.dart';
import '../../mypayments/widget/child_payment_card_widget.dart';
import '../../mypayments/widget/payment_list_widget.dart';

class DetailsPaymentChild extends StatefulWidget {
  final int? studentId;
  final Mychildreen? student;
  const DetailsPaymentChild(
      {Key? key,  this.studentId,  this.student})
      : super(key: key);

  @override
  State<DetailsPaymentChild> createState() => _DetailsPaymentChildState();
}

class _DetailsPaymentChildState extends State<DetailsPaymentChild> {
  final PaymentsController paymentController = Get.find<PaymentsController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      paymentController.fetchingTotalPaymentsStudents(widget.studentId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color:CupertinoColors.white),
          onPressed: () {
            Get.back();
          },
        ),

        centerTitle: true,
        elevation: 0,
        backgroundColor: primarycolor,
        title:  Text(
          'mypayments'.tr,
          style: TextStyle(color: CupertinoColors.white,fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          final controller = Get.find<PaymentsController>();

          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressBar(
                color: primarycolor,
              ),
            );
          } else if (controller.paymentsTotalstudents.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/imgs/notfound.png'),
                Text('nopayments'.tr),
              ],
            );
          }else {
            return ListView(
              children: [
                ChildCardPayment(
                  student: widget.student!,
                ),
                const SizedBox(height: 15),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.paymentsTotalstudents.length,
                  itemBuilder: (context, index) {
                    final paymentTotal = controller.paymentsTotalstudents[index];
                    return PaymentListItem(
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











