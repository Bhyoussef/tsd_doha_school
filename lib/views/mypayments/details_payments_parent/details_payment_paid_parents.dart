import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/payment_controller/payments_controller.dart';
import '../../../theme/app_colors.dart';

class DetailPaymentsPaidParents extends StatefulWidget {
  const DetailPaymentsPaidParents({super.key});

  @override
  State<DetailPaymentsPaidParents> createState() =>
      _DetailPaymentsPaidParentsState();
}

class _DetailPaymentsPaidParentsState extends State<DetailPaymentsPaidParents> {
  final PaymentsController controller = Get.put(PaymentsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: primarycolor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: CupertinoColors.white),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text(
            'Total Paid',
            style: TextStyle(color: CupertinoColors.white,
                fontWeight: FontWeight.bold),
          ),
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
          child: Obx(
            () {
              if (controller.isLoading.value) {
                return  Center(child: CircularProgressIndicator(color: primarycolor,));
              } else {
                return ListView.builder(
                  itemCount: controller.totalpaiddetailsparents.length,
                  itemBuilder: (context, index) {
                    final paidDetail =
                        controller.totalpaiddetailsparents[index];
                    return Card(
                      margin: const EdgeInsets.all(12.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                            const Divider(),
                            Text(
                              'Price Unit: ${paidDetail.priceUnit}',
                            ),
                            const Divider(),
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
          ),
        ));
  }
}
