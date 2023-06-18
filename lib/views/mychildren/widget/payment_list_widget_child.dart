import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/child_model.dart';
import '../../../model/payment_model.dart';
import '../../mypayments/details_payments_parent/details_payment_paid_parents.dart';
import '../payments/total_impaid_child.dart';

class PaymentChildListItem extends StatelessWidget {
  final Payment? paymentTotal;
  final Mychildreen? student;
  const PaymentChildListItem({Key? key, this.paymentTotal, this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
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
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              ListTile(
                title:  Text(
                  'totalpaid'.tr,
                  style:const  TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${double.parse(paymentTotal!.totPaid!).toStringAsFixed(0)} ${paymentTotal!.currency!}'),
                trailing: const Icon(
                  Icons.payment,
                  color: Colors.green,
                ),
                onTap: () {
                  Get.to(() =>  DetailPaymentsPaidParents(

                  ),transition: Transition.cupertinoDialog,duration: Duration(seconds: 1));
                },
              ),
              const Divider(),
              ListTile(
                title:  Text(
                  'totalunpaid'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${double.parse(paymentTotal!.totUnpaid!).toStringAsFixed(0)} ${paymentTotal!.currency!}'),
                trailing: const Icon(
                  Icons.payment,
                  color: Colors.red,
                ),
                onTap: () {
                  Get.to(() =>  TotalImpaidChild(student: student,),transition: Transition.cupertinoDialog,duration: Duration(seconds: 1));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
