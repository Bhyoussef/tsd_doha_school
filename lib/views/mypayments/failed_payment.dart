import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../home/home_screen.dart';

class FailedPayment extends StatelessWidget {
  const FailedPayment({Key? key}) : super(key: key);

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
                const Text(
                  'Payment Failed',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    'The Payment has failed, please try again.',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(()=>HomeScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                      minimumSize: Size(
                        MediaQuery.of(context).size.width - 100,
                        50,
                      ),
                    ),
                    child: const Text('Return'),
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
