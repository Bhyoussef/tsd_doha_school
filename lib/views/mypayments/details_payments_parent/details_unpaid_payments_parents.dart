import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/constant/constant.dart';
import 'package:tsdoha/controller/payment_controller/payments_controller.dart';
import 'package:tsdoha/routes/routes.dart';
import 'package:tsdoha/theme/app_colors.dart';



class DetailPaymentsUnpaidParents extends StatefulWidget {

  const DetailPaymentsUnpaidParents({super.key});

  @override
  State<DetailPaymentsUnpaidParents> createState() => _DetailPaymentsUnpaidParentsState();
}

class _DetailPaymentsUnpaidParentsState extends State<DetailPaymentsUnpaidParents> {
  final PaymentsController controller = Get.put(PaymentsController());



  @override
  Widget build(BuildContext context) {
    final locale = Get.locale;
    final isArabic = locale?.languageCode == 'ar';
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
          title:  Text('totalunpaid'.tr,style: const TextStyle(
              color: CupertinoColors.white,fontWeight: FontWeight.bold
          ),),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  Get.toNamed(Routes.home);
                },
                child: Image.asset(
                  'assets/imgs/tsdIcon.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Obx(
                () {
              if (controller.isloading.value) {
                return  Center(child: CircularProgressBar(
                  color: primarycolor,
                ));
              } else {
                return ListView.builder(
                  itemCount: controller.totalinpaiddetailsparents.length,
                  itemBuilder: (context, index) {
                    final paidDetail = controller.totalinpaiddetailsparents[index];
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
                              ' ${paidDetail.priceUnit!.toInt()} ${paidDetail.currency}',
                            ),

                            isArabic?Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                ' ${paidDetail.year}',
                              ),
                            ):Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                ' ${paidDetail.year}',
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
        )
    );
  }
}