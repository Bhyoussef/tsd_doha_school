import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:tunisian_school_doha/model/child_model.dart';

import '../../../controller/payment_controller/payments_controller.dart';
import '../../../model/payment_details_model.dart';
import '../../../model/payment_model.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/shared_preferences.dart';
import '../../mypayments/payment_screen.dart';

class DetailsPaymentChild extends StatefulWidget {

  final int studentId;
  final Mychildreen student;
   DetailsPaymentChild({Key? key, required this.studentId, required this.student}) : super(key: key);

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
        title: const Text('Payment',style: TextStyle(color: Color(0xFF7590d6)),),
        
      ),
      body: ListView(
        children: [
          ChildCardPayment(student: widget.student,),
          GetBuilder<PaymentsController>(
            init: PaymentsController(),
            builder: (controller) {
              if (controller.paymentsTotalstudents.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.paymentsTotalstudents.length,
                itemBuilder: (context, index) {
                  final paymentTotal = controller.paymentsTotalstudents[index];
                  return PaymentListItem(paymentTotal: paymentTotal,student: widget.student,);
                },
              );
            },
          )

        ],
      ),
    );
  }
}




class ChildCardPayment extends StatelessWidget {
  final Mychildreen student;

  const ChildCardPayment({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCircleAvatar(student.image),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '${student.name ?? ''} ${student.lastName ?? ''}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Widget _buildCircleAvatar(dynamic image) {
  if (image != null) {
    try {
      final decodedImage = base64Decode(image.toString());
      final imageBytes = Uint8List.fromList(decodedImage);
      return CircleAvatar(
        backgroundImage: MemoryImage(imageBytes),
        radius: 30.0,
      );
    } catch (e) {

      print('Invalid image data: $e');
    }
  }
  return const CircleAvatar(
    backgroundImage: AssetImage("assets/imgs/user-avatar.png"),
    radius: 30.0,
  );
}


class PaymentListItem extends StatelessWidget {
  final Payment paymentTotal;
  final Mychildreen student;

  const PaymentListItem({Key? key, required this.paymentTotal, required this.student}) : super(key: key);

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
                title: const Text('Total Paid'),
                subtitle: Text(paymentTotal.totPaid.toString()),
                trailing: const Icon(Icons.payment,color: Colors.green,),

                onTap: () {
                  Get.to(() =>  TotalPaymentsChild(student: student,));
                },

              ),
              ListTile(
                title: const Text('Total Inpaid'),
                subtitle:Text(paymentTotal.totUnpaid.toString()) ,
                trailing: const Icon(Icons.payment,color: Colors.red,),
                onTap: () {
                  Get.to(() =>  TotalImpaidChild(student:student));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TotalPaymentsChild extends StatefulWidget {
  final Mychildreen student;
  TotalPaymentsChild({Key? key, required this.student}) : super(key: key);

  @override
  State<TotalPaymentsChild> createState() => _TotalPaymentsChildState();
}

class _TotalPaymentsChildState extends State<TotalPaymentsChild> {
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,color: Color(0xFFB97CFC),),
            onPressed: () {
              Get.back();
            },
          ),
          backgroundColor: Colors.white,
          title: const Text('Total Paid',style: TextStyle(
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
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: CupertinoColors.white,),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        title: Text('Total Unpaid',style: TextStyle(
          color: Color(0xFF7590d6)
        ),),
      ),
      body: SafeArea(
        child: Obx(
              () {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: controller.totalinpaiddetailsstudents.length,
                itemBuilder: (context, index) {
                  final paidDetail = controller.totalinpaiddetailsstudents[index];

                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        paidDetail.period.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price Unit: ${paidDetail.priceUnit}'),
                          Text('Year: ${paidDetail.year}'),
                        ],
                      ),
                      trailing: Switch(
                        activeColor: const Color(0xFFB97CFC),
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
        minWidth: MediaQuery.of(context).size.width-30,
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
        child:const  Text('Pay',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      bottomNavigationBar: Padding(
        padding:const EdgeInsets.all(16),
        child: Text(
          'Total Amount: $totalAmount',
          style:  TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primarycolor
          ),
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

  void navigateToPaymentPage(BuildContext context,
      List<PaymentDetails> selectedDetails) {
    List<int> lineIDs =
    selectedDetails.map((detail) => detail.idLine!).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PaymentScreen(
              schoolCode: widget.student.schoolCode!,
              parentID: parentId,
              childID: widget.student.studentId!,
              amount: totalAmount,
              lineIDs: lineIDs,
              student:widget.student
            ),
      ),
    );
  }
}
