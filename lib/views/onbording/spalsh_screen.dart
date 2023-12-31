import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/theme/app_colors.dart';
import 'language_page.dart';
import 'widget/topandbuttomwrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    pushNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarycolor,
      body: TopAndBottomTextureWrapper(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 224,
              width: 224,
              child: Image.asset('assets/imgs/tsdIcon.png'),
            ),
            Column(
              children: [
                Text(
                  'Tunisian School Doha',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontFamily: 'Bahij',
                  ),
                ),
                Text(
                  'المدرسة التونسية بالدوحة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontFamily: 'Bahij',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Version 2.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Bahij',
                fontWeight: FontWeight.w100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pushNextScreen() async {
    await Future.delayed(const Duration(seconds: 4));
    Get.to(() => const LanguageScreen());
  }
}
