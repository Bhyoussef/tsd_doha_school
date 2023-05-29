import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/constant.dart';
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
        title:  Text('totalpaid'.tr,style:const TextStyle(
            color: CupertinoColors.white,fontWeight: FontWeight.bold
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
              () {
            if (paymentController.isLoading.value) {
              return Center(
                child: CircularProgressBar(color: primarycolor,),
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
                return Container(
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
                          payment.period.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' ${payment.priceUnit} ${payment.currency}',
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            ' ${payment.year}',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );

          },
        ),
      )
    );
  }


}
