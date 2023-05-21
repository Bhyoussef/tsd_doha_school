import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:tunisian_school_doha/model/child_model.dart';
import '../../../controller/payment_controller/payments_controller.dart';

class TotalPaymentsChildren extends StatefulWidget {
  final Mychildreen student;
    TotalPaymentsChildren({Key? key, required this.student}) : super(key: key);

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
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Color(0xFFB97CFC),),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Total Payment',style: TextStyle(
            color: Color(0xFF7590d6)
        ),),
      ),
      body: Obx(
            () {
          if (paymentController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (paymentController.totalpaiddetailsstudents.isEmpty) {
            return Center(
              child: Text('No payments history found.'),
            );
          }

          return  ListView.builder(
            itemCount: paymentController.totalpaiddetailsstudents.length,
            itemBuilder: (context, index) {
              final payment = paymentController.totalpaiddetailsstudents[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment.period.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      Text(
                        'Price Unit: ${payment.priceUnit}',
                      ),
                      Divider(),
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
