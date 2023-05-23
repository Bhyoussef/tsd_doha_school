import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../model/payment_model.dart';
import '../details_payments_parent/details_payment_paid_parents.dart';
import '../details_payments_parent/details_unpaid_payments_parents.dart';


class PaymentListItem extends StatelessWidget {
  final Payment paymentTotal;

  const PaymentListItem({Key? key, required this.paymentTotal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
                title: const Text('Total Paid',style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text(paymentTotal.totPaid.toString()),
                trailing: const Icon(Icons.payment,color: Colors.green,),

                  onTap: () {
                    Get.to(() =>  DetailPaymentsPaidParents());
                  },

              ),
              ListTile(
                title: const Text('Total Inpaid',style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle:Text(paymentTotal.totUnpaid.toString()) ,
                trailing: const Icon(Icons.payment,color: Colors.red,),
                onTap: () {
                  Get.to(() =>  DetailPaymentsUnpaidParents());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}