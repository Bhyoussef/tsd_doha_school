import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/payment_controller/payments_controller.dart';


class DetailPaymentsPaidParents extends StatefulWidget {

  DetailPaymentsPaidParents({super.key});

  @override
  State<DetailPaymentsPaidParents> createState() => _DetailPaymentsPaidParentsState();
}

class _DetailPaymentsPaidParentsState extends State<DetailPaymentsPaidParents> {
  final PaymentsController controller = Get.put(PaymentsController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Color(0xFFB97CFC),),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text('Total Paid',style: TextStyle(
              color: Color(0xFF7590d6)
          ),),
        ),
        body: Obx(
              () {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: controller.totalpaiddetailsparents.length,
                itemBuilder: (context, index) {
                  final paidDetail = controller.totalpaiddetailsparents[index];

                  return Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            paidDetail.period.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(),
                          Text(
                            'Price Unit: ${paidDetail.priceUnit}',
                          ),
                          Divider(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'Year: ${paidDetail.year}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        )
    );
  }
}