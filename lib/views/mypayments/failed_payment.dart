import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/model/child_model.dart';
import 'package:tsdoha/views/home/home_screen.dart';

class FailedPayment extends StatefulWidget {
  final Mychildreen? student;
  const FailedPayment({Key? key, this.student}) : super(key: key);

  @override
  State<FailedPayment> createState() => _FailedPaymentState();
}

class _FailedPaymentState extends State<FailedPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width/2,
                  child: Image.asset('assets/imgs/failed.png', fit: BoxFit.cover),
                ),
                const SizedBox(height: 20),
                 Text(
                  'paymentfailed'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:  Text(
                    'paymentfail'.tr,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAll(()=>HomeScreen(

                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                      minimumSize: Size(
                        MediaQuery.of(context).size.width - 100,
                        50,
                      ),
                    ),
                    child:  Text('return'.tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
