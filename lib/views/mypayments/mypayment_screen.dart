import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/constant/constant.dart';
import 'package:tsdoha/controller/mychildren_controller/mychildren_controller.dart';
import 'package:tsdoha/controller/payment_controller/payments_controller.dart';
import 'package:tsdoha/theme/app_colors.dart';
import 'details_payment_children/details_payment_children.dart';
import 'widget/child_payment_card_widget.dart';
import 'widget/payment_list_widget.dart';

class MyPaymentsScreen extends StatelessWidget {
  final controllerchildren = Get.put(ChildrenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final controller = Get.find<PaymentsController>();

        if (controller.paymentsTotalparents.isEmpty) {
          return Center(
            child: CircularProgressBar(color: primarycolor,),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controllerchildren.children.length,
                itemBuilder: (context, index) {
                  final child = controllerchildren.children[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => TotalPaymentsChildren(
                        student: controllerchildren.children[index],
                      ),transition: Transition.cupertino,duration: Duration(seconds: 1));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 2, top: 20),
                      child: ChildCardPayment(student: child),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20,),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.paymentsTotalparents.length,
                itemBuilder: (context, index) {
                  final paymentTotal = controller.paymentsTotalparents[index];
                  return PaymentListItem(paymentTotal: paymentTotal);
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
