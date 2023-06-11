import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constant/constant.dart';
import '../../../controller/payment_controller/payments_controller.dart';
import '../../../model/child_model.dart';
import '../../../theme/app_colors.dart';

class TotalPaymentsChild extends StatefulWidget {
  final Mychildreen student;
  const TotalPaymentsChild({Key? key, required this.student}) : super(key: key);

  @override
  State<TotalPaymentsChild> createState() => _TotalPaymentsChildState();
}

class _TotalPaymentsChildState extends State<TotalPaymentsChild> {
  final PaymentsController paymentController = Get.find<PaymentsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      paymentController
          .fetchingTotalPaymentsStudentsDetail(widget.student.studentId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = Get.locale;
    final isArabic = locale?.languageCode == 'ar';
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
            'totalpaid'.tr,
            style:const TextStyle(
              color: CupertinoColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Obx(
              () {
            if (paymentController.isloading.value) {
              return  Center(
                child: CircularProgressBar(color: primarycolor,),
              );
            } else if (paymentController.totalpaiddetailsstudents.isEmpty) {
              return const Center(
                child: Text('No payments history found.'),
              );
            }

            return ListView.builder(
              itemCount: paymentController.totalpaiddetailsstudents.length,
              itemBuilder: (context, index) {
                final payment =
                paymentController.totalpaiddetailsstudents[index];
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment.period.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${payment.priceUnit!.toInt()} ${payment.currency}',
                      ),
                      isArabic?Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          '${payment.year}',
                        ),
                      ):Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          '${payment.year}',
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ));
  }
}