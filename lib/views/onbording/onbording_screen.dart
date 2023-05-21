import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tunisian_school_doha/utils/shared_preferences.dart';
import '../../routes/routes.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imgs/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('English'),
                  onPressed: () {
                    SharedData.saveToStorage('language', 'en', 'string');
                    Get.toNamed(Routes.getloginscreen());
                  },
                ),
                ElevatedButton(
                  child: const Text('Arabic'),
                  onPressed: () {
                    SharedData.saveToStorage('language', 'ar', 'string');
                    Get.toNamed(Routes.getloginscreen());
                  },
                ),
                ElevatedButton(
                  child: const Text('French'),
                  onPressed: () {
                    SharedData.saveToStorage('language', 'fr', 'string');
                    Get.toNamed(Routes.getloginscreen());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
