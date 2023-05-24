import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tunisian_school_doha/theme/app_colors.dart';
import '../../controller/language_controller/language_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
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
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
