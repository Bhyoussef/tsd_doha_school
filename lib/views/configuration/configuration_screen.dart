import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/controller/language_controller/language_controller.dart';
import 'package:tsdoha/main_screen.dart';
import 'package:tsdoha/theme/app_colors.dart';
import 'package:tsdoha/utils/shared_preferences.dart';
import 'package:tsdoha/views/home/home_screen.dart';
import 'package:tsdoha/views/onbording/spalsh_screen.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
   
            Expanded(
              child: ListView(
                children: <Widget>[
                  GetBuilder<LanguageController>(
                    init: LanguageController(),
                    builder: (controller) => CheckboxListTile(
                      checkColor: Colors.white,
                      activeColor: primarycolor,
                      title: Text('anglais'.tr),
                      value: controller.savedLang.value == 'EN',
                      onChanged: (bool? value) {
                        if (value != null && value) {
                          controller.changeLanguage('EN');
                          SharedData.saveToStorage('language', 'en', 'string');
                          Get.updateLocale(const Locale('en'));


                        }
                      },
                    ),
                  ),
                  GetBuilder<LanguageController>(
                    init: LanguageController(),
                    builder: (controller) => CheckboxListTile(
                      checkColor: Colors.white,
                      activeColor: primarycolor,
                      title: Text('arabe'.tr),
                      value: controller.savedLang.value == 'AR',
                      onChanged: (bool? value) {
                        if (value != null && value) {
                          controller.changeLanguage('AR');
                          SharedData.saveToStorage('language', 'ar', 'string');
                          Get.updateLocale(const Locale('ar'));


                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
