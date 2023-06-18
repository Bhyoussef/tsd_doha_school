import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/model/child_model.dart';
import '../home/home_screen.dart';

class SuccsesPayament extends StatefulWidget {
  final double? amount;
  final Mychildreen? student;

  const SuccsesPayament({Key? key, this.amount, this.student}) : super(key: key);

  @override
  State<SuccsesPayament> createState() => _SuccsesPayamentState();
}

class _SuccsesPayamentState extends State<SuccsesPayament> {
  @override
  Widget build(BuildContext context) {
    String  payment1='payment1'.tr;
    String  payment2='payment2'.tr;

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
                  width: MediaQuery.of(context).size.width / 2,
                  child: Image.asset('assets/imgs/success.png', fit: BoxFit.cover),
                ),
                const SizedBox(height: 20),
                 Text(
                  'paymentsucces'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'paymentok'.tr,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width - 100,
                    height: 50,
                    color: Colors.green,
                    textColor: Colors.white,
                    onPressed: () {
                      Get.offAll(()=>HomeScreen());
                    },
                    child:  Text('continue'.tr),
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
