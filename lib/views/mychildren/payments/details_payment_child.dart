import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/constant.dart';
import '../../../controller/payment_controller/payments_controller.dart';
import '../../../model/child_model.dart';
import '../../../model/payment_details_model.dart';
import '../../../model/payment_model.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/shared_preferences.dart';
import '../../mypayments/payment_screen.dart';

class DetailsPaymentChild extends StatefulWidget {
  final int studentId;
  final Mychildreen student;
  const DetailsPaymentChild(
      {Key? key, required this.studentId, required this.student})
      : super(key: key);

  @override
  State<DetailsPaymentChild> createState() => _DetailsPaymentChildState();
}

class _DetailsPaymentChildState extends State<DetailsPaymentChild> {
  final PaymentsController paymentController = Get.find<PaymentsController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      paymentController.fetchingTotalPaymentsStudents(widget.studentId);
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
          'mypayments'.tr,
          style: TextStyle(color: CupertinoColors.white,fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        final controller = Get.find<PaymentsController>();

        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressBar(
              color: primarycolor,
            ),
          );
        } else if (controller.paymentsTotalstudents.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/imgs/notfound.png'),
              Text('nopayments'.tr),
            ],
          );
        }else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                ChildCardPayment(
                  student: widget.student,
                ),
                const SizedBox(height: 15),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.paymentsTotalstudents.length,
                  itemBuilder: (context, index) {
                    final paymentTotal = controller.paymentsTotalstudents[index];
                    return PaymentListItem(
                      paymentTotal: paymentTotal,
                      student: widget.student,
                    );
                  },
                ),
              ],
            ),
          );
        }
      }),


    );
  }
}

class ChildCardPayment extends StatelessWidget {
  final Mychildreen student;

  const ChildCardPayment({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Get.locale;
    final isArabic = locale?.languageCode == 'ar';
    return Container(
      padding: const EdgeInsets.all(8),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCircleAvatar(student.image),
          const SizedBox(width: 10),
          Text(
            isArabic?'${student.nameAr ?? ''} ${student.lastNameAr ?? ''}': '${student.name ?? ''} ${student.lastName ?? ''}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCircleAvatar(dynamic image) {
  if (image != null) {
    try {
      final decodedImage = base64Decode(image.toString());
      final imageBytes = Uint8List.fromList(decodedImage);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundImage: MemoryImage(imageBytes),
          radius: 30.0,
        ),
      );
    } catch (e) {
      print('Invalid image data: $e');
    }
  }
  return const Padding(
    padding: EdgeInsets.all(8.0),
    child: CircleAvatar(
      backgroundImage: AssetImage("assets/imgs/user-avatar.png"),
      radius: 30.0,
    ),
  );
}

class PaymentListItem extends StatelessWidget {
  final Payment paymentTotal;
  final Mychildreen student;

  const PaymentListItem(
      {Key? key, required this.paymentTotal, required this.student})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            ListTile(
              title:  Text('totalpaid'.tr),
              subtitle: Text('${paymentTotal.totPaid.toString()} ${paymentTotal.currency}'),
              trailing: const Icon(
                Icons.payment,
                color: Colors.green,
              ),
              onTap: () {
                Get.to(() => TotalPaymentsChild(
                      student: student,
                    ));
              },
            ),
            const Divider(),
            ListTile(
              title:  Text('totalunpaid'.tr),
              subtitle: Text('${paymentTotal.totUnpaid.toString()} ${paymentTotal.currency}'),
              trailing: const Icon(
                Icons.payment,
                color: Colors.red,
              ),
              onTap: () {
                Get.to(() => TotalImpaidChild(student: student));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TotalPaymentsChild extends StatefulWidget {
  final Mychildreen student;
  const TotalPaymentsChild({Key? key, required this.student}) : super(key: key);

  @override
  State<TotalPaymentsChild> createState() => _TotalPaymentsChildState();
}

class _TotalPaymentsChildState extends State<TotalPaymentsChild> {
  final PaymentsController paymentController = Get.find<PaymentsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      paymentController
          .fetchingTotalPaymentsStudentsDetail(widget.student.studentId!);
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
            'totalpaid'.tr,
            style:const TextStyle(
              color: CupertinoColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Obx(
          () {
            if (paymentController.isLoading.value) {
              return  Center(
                child: CircularProgressBar(color: primarycolor,),
              );
            } else if (paymentController.totalpaiddetailsstudents.isEmpty) {
              return const Center(
                child: Text('No payments history found.'),
              );
            }

            return ListView.builder(
              itemCount: paymentController.totalpaiddetailsstudents.length,
              itemBuilder: (context, index) {
                final payment =
                    paymentController.totalpaiddetailsstudents[index];
                return Container(
                  padding: const EdgeInsets.all(18),
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
                        'Price Unit: ${payment.priceUnit} ${payment.currency}',
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'Year: ${payment.year}',
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ));
  }
}

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
