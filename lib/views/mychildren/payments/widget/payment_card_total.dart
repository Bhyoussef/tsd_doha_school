import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/model/child_model.dart';
import 'package:tsdoha/model/payment_model.dart';
import 'package:tsdoha/views/mychildren/payments/total_impaid_child.dart';
import 'package:tsdoha/views/mychildren/payments/total_paid_child.dart';


class PaymentListItem extends StatelessWidget {
  final Payment paymentTotal;
  final Mychildreen student;

  const PaymentListItem(
      {Key? key, required this.paymentTotal, required this.student})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Container(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            ListTile(
              title:  Text('totalpaid'.tr),
              subtitle: Text('${paymentTotal.totPaid.toString()} ${paymentTotal.currency}'),
              trailing: const Icon(
                Icons.payment,
                color: Colors.green,
              ),
              onTap: () {
                Get.to(() => TotalPaymentsChild(
                  student: student,
                ));
              },
            ),
            const Divider(),
            ListTile(
              title:  Text('totalunpaid'.tr),
              subtitle: Text('${paymentTotal.totUnpaid.toString()} ${paymentTotal.currency}'),
              trailing: const Icon(
                Icons.payment,
                color: Colors.red,
              ),
              onTap: () {
                Get.to(() => TotalImpaidChild(student: student));
              },
            ),
          ],
        ),
      ),
    );
  }
}