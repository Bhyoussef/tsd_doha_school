import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/payment_controller/payments_controller.dart';
import '../../../model/child_model.dart';
import '../../../theme/app_colors.dart';

class TotalPaymentsChildren extends StatefulWidget {
  final Mychildreen student;
    const TotalPaymentsChildren({Key? key, required this.student}) : super(key: key);

  @override
  State<TotalPaymentsChildren> createState() => _TotalPaymentsChildrenState();
}

class _TotalPaymentsChildrenState extends State<TotalPaymentsChildren> {
  final PaymentsController paymentController = Get.find<PaymentsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      paymentController.fetchingTotalPaymentsStudentsDetail(
          widget.student.studentId!);
    });

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
        title: const Text('Total Payment',style: TextStyle(
            color: CupertinoColors.white,fontWeight: FontWeight.bold
        ),),
      ),
      body: Obx(
            () {
          if (paymentController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: primarycolor,),
            );
          } else if (paymentController.totalpaiddetailsstudents.isEmpty) {
            return const Center(
              child: Text('No payments history found.'),
            );
          }

          return  ListView.builder(
            itemCount: paymentController.totalpaiddetailsstudents.length,
            itemBuilder: (context, index) {
              final payment = paymentController.totalpaiddetailsstudents[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                      const Divider(),
                      Text(
                        'Price Unit: ${payment.priceUnit}',
                      ),
                      const Divider(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'Year: ${payment.year}',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );

        },
      )
    );
  }


}
