import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../home/home_screen.dart';

class SuccsesPayament extends StatelessWidget {
  final double? amount;

  const SuccsesPayament({Key? key, this.amount}) : super(key: key);

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
                  width: MediaQuery.of(context).size.width / 2,
                  child: Image.asset('assets/imgs/success.png', fit: BoxFit.cover),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Payment Successful',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'The Payment of ${amount!.toStringAsFixed(2)} QAR has been successfully sent to Tsdoha from your wallet.',
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
                      Get.to(()=>HomeScreen());
                    },
                    child: const Text('Complete'),
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
