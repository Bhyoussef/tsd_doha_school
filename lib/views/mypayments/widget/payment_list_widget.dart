import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../model/payment_model.dart';
import '../details_payments_parent/details_payment_paid_parents.dart';
import '../details_payments_parent/details_unpaid_payments_parents.dart';

class PaymentListItem extends StatelessWidget {
  final Payment? paymentTotal;

  const PaymentListItem({Key? key,  this.paymentTotal})
      : super(key: key);

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
                subtitle: Text('${paymentTotal!.totPaid!.toString()} ${paymentTotal!.currency!}'),
                trailing: const Icon(
                  Icons.payment,
                  color: Colors.green,
                ),
                onTap: () {
                  Get.to(() => DetailPaymentsPaidParents());
                },
              ),
              const Divider(),
              ListTile(
                title:  Text(
                  'totalunpaid'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${paymentTotal!.totUnpaid!.toString()} ${paymentTotal!.currency!}'),
                trailing: const Icon(
                  Icons.payment,
                  color: Colors.red,
                ),
                onTap: () {
                  Get.to(() => const DetailPaymentsUnpaidParents());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
