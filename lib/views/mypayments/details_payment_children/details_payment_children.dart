import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/constant/constant.dart';
import 'package:tsdoha/controller/payment_controller/payments_controller.dart';
import 'package:tsdoha/model/child_model.dart';
import 'package:tsdoha/theme/app_colors.dart';
import 'package:tsdoha/views/home/home_screen.dart';

class TotalPaymentsChildren extends StatefulWidget {
  final Mychildreen? student;
  const TotalPaymentsChildren({Key? key, this.student}) : super(key: key);

  @override
  State<TotalPaymentsChildren> createState() => _TotalPaymentsChildrenState();
}

class _TotalPaymentsChildrenState extends State<TotalPaymentsChildren> {
  final PaymentsController paymentController = Get.find<PaymentsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      paymentController
          .fetchingTotalPaymentsStudentsDetail(widget.student!.studentId!);
    });
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      paymentController
          .fetchingTotalUnPaymentsStudentsDetail(widget.student!.studentId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = Get.locale;
    final isArabic = locale?.languageCode == 'ar';

    return DefaultTabController(
      length: 2, // Two tabs: Paid and Unpaid
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: primarycolor,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: CupertinoColors.white,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            isArabic ?widget.student!.nameAr.toString():widget.student!.name.toString(),
            style: const TextStyle(
              color: CupertinoColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Get.offAll(HomeScreen());
                },
                child: Image.asset(
                  'assets/imgs/tsdIcon.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'totalpaid'.tr),
              Tab(text: 'totalunpaid'.tr),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Paid tab content
            Obx(() => paymentController.isloading.isTrue
                ? Center(
                    child: CircularProgressBar(
                      color: primarycolor,
                    ),
                  )
                : paymentController.totalpaiddetailsstudents.isNotEmpty
                    ? ListView.builder(
                        itemCount:
                            paymentController.totalpaiddetailsstudents.length,
                        itemBuilder: (context, index) {
                          final payment =
                              paymentController.totalpaiddetailsstudents[index];
                          return Container(
                            padding: const EdgeInsets.all(14),
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
                                  ' ${payment.priceUnit!.toStringAsFixed(0)} ${payment.currency}',
                                ),
                                isArabic
                                    ? Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          ' ${payment.year}',
                                        ),
                                      )
                                    : Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          ' ${payment.year}',
                                        ),
                                      ),
                              ],
                            ),
                          );
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/imgs/notfound.png'),
                          Text('nopayments'.tr),
                        ],
                      )),

            // Unpaid tab content
            Obx(() => paymentController.isloading.isTrue
                ? Center(
                    child: CircularProgressBar(
                      color: primarycolor,
                    ),
                  )
                : paymentController.totalunpaidchild.isNotEmpty
                    ? ListView.builder(
                        itemCount: paymentController.totalunpaidchild.length,
                        itemBuilder: (context, index) {
                          final payment =
                              paymentController.totalunpaidchild[index];
                          return Container(
                            padding: const EdgeInsets.all(14),
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
                                  ' ${payment.priceUnit!.toStringAsFixed(0)} ${payment.currency}',
                                ),
                                isArabic
                                    ? Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          ' ${payment.year}',
                                        ),
                                      )
                                    : Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          ' ${payment.year}',
                                        ),
                                      ),
                              ],
                            ),
                          );
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/imgs/notfound.png'),
                          Text('nopayments'.tr),
                        ],
                      )),
          ],
        ),
      ),
    );
  }
}
