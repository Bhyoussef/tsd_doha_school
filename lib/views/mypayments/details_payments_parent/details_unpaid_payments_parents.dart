import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tunisian_school_doha/theme/app_colors.dart';

import '../../../controller/payment_controller/payments_controller.dart';


class DetailPaymentsUnpaidParents extends StatefulWidget {

  const DetailPaymentsUnpaidParents({super.key});

  @override
  State<DetailPaymentsUnpaidParents> createState() => _DetailPaymentsUnpaidParentsState();
}

class _DetailPaymentsUnpaidParentsState extends State<DetailPaymentsUnpaidParents> {
  final PaymentsController controller = Get.put(PaymentsController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: primarycolor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,color: CupertinoColors.white,),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text('Total Unpaid',style: TextStyle(
              color: CupertinoColors.white,fontWeight: FontWeight.bold
          ),),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/imgs/tsdIcon.png',
                width: 40,
                height: 40,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
                  () {
                if (controller.isLoading.value) {
                  return  Center(child: CircularProgressIndicator(
                    color: primarycolor,
                  ));
                } else {
                  return ListView.builder(
                    itemCount: controller.totalinpaiddetailsparents.length,
                    itemBuilder: (context, index) {
                      final paidDetail = controller.totalinpaiddetailsparents[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(0.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  paidDetail.period.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(
                                  'Price Unit: ${paidDetail.priceUnit} ${paidDetail.currency}',
                                ),

                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    'Year: ${paidDetail.year}',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        )
    );
  }
}