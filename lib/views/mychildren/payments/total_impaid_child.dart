import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../mypayments/payment_screen.dart';
import '../../../constant/constant.dart';
import '../../../controller/payment_controller/payments_controller.dart';
import '../../../model/child_model.dart';
import '../../../model/payment_details_model.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/shared_preferences.dart';

class TotalImpaidChild extends StatefulWidget {
  final Mychildreen student;
  const TotalImpaidChild({Key? key, required this.student}) : super(key: key);

  @override
  _TotalImpaidChildState createState() => _TotalImpaidChildState();
}

class _TotalImpaidChildState extends State<TotalImpaidChild> {
  final PaymentsController controller = Get.put(PaymentsController());
  List<int> selectedLines = [];
  late int parentId;
  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
      setState(() {
        parentId = uid;
      });
    });

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      controller.fetchingTotalInPaidDetailsStudent(widget.student.studentId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color:CupertinoColors.white),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primarycolor,
        title:  Text(
          'totalunpaid'.tr,
          style: const TextStyle(
            color: CupertinoColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(
              () {
            if (controller.isLoading.value) {
              return  Center(
                child: CircularProgressBar(color: primarycolor,),
              );
            } else {
              return ListView.builder(
                itemCount: controller.totalinpaiddetailsstudents.length,
                itemBuilder: (context, index) {
                  final paidDetail =
                  controller.totalinpaiddetailsstudents[index];

                  return Container(
                    padding: const EdgeInsets.all(14),
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
                    child: ListTile(
                      title: Text(
                        paidDetail.period.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${paidDetail.priceUnit} ${paidDetail.currency}'),
                          Text('${paidDetail.year}'),
                        ],
                      ),
                      trailing: CupertinoSwitch(
                        activeColor: primarycolor,
                        value: selectedLines.contains(index),
                        onChanged: (value) {
                          setState(() {
                            if (value) {
                              selectedLines.add(index);
                            } else {
                              selectedLines.remove(index);
                            }
                            totalAmount = calculateTotalAmount();
                          });
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: MaterialButton(
        height: 50,
        minWidth: MediaQuery.of(context).size.width - 30,
        color: primarycolor,
        textColor: Colors.white,
        onPressed: () {
          if (selectedLines.isNotEmpty) {
            List<PaymentDetails> selectedDetails = selectedLines
                .map((index) => controller.totalinpaiddetailsstudents[index])
                .toList();
            navigateToPaymentPage(context, selectedDetails);
          }
        },
        child: Text(
          totalAmount == 0.0 ? 'select'.tr : '${'pay'.tr} $totalAmount QAR',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  double calculateTotalAmount() {
    double total = 0;
    for (int index in selectedLines) {
      final paidDetail = controller.totalinpaiddetailsstudents[index];
      total += paidDetail.priceUnit!;
    }
    return total;
  }

  void navigateToPaymentPage(
      BuildContext context, List<PaymentDetails> selectedDetails) {
    List<int> lineIDs =
    selectedDetails.map((detail) => detail.idLine!).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          schoolCode: widget.student.schoolCode!,
          parentID: parentId,
          childID: widget.student.studentId!,
          amount: totalAmount,
          lineIDs: lineIDs,
          student: widget.student,
        ),
      ),
    );
  }
}