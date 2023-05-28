import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../utils/shared_preferences.dart';
import 'widget/topandbuttomwrapper.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

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
                child: Image.asset('assets/imgs/langPic.png')),
            const SizedBox(
              height: 45,
            ),
            const Text(
              'Choose your preferred language',
              style: TextStyle(
                fontFamily: 'Bahij',
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'اختر لغتك المفضلة',
              style: TextStyle(
                fontFamily: 'Bahij',
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 37),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  width: 200,
                  child: TextButton(
                    onPressed: () async {
                      SharedData.saveToStorage('language', 'en', 'string');
                      Get.updateLocale(const Locale('en'));
                      Get.toNamed(Routes.getloginscreen());
                    },
                    style: PadiwanButtonTheme.whiteButtonTheme.style,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/imgs/ukFlag.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'English',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColor.primaryBlueColor),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: TextButton(
                    onPressed: () async {
                      SharedData.saveToStorage('language', 'ar', 'string');
                      Get.updateLocale(const Locale('ar'));
                       Get.toNamed(Routes.getloginscreen());
                    },
                    style: PadiwanButtonTheme.blueButtonTheme.style,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'عربي',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Image.asset(
                          'assets/imgs/qatarFlag.png',
                          width: 25,
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
