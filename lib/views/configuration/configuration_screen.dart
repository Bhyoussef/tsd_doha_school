import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/language_controller/language_controller.dart';



class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50,),
          Expanded(
            child: ListView(
              children: <Widget>[
                GetBuilder<LanguageController>(
                  init: LanguageController(),
                  builder: (controller) => CheckboxListTile(
                    checkColor: Colors.white,
                    activeColor: const Color(0xFFB97CFC),
                    title:  Text('anglais'.tr),
                    value: controller.savedLang.value == 'EN',
                    onChanged: (bool? value) {
                      if (value != null && value) {
                        controller.savedLang.value = 'EN';
                        Get.updateLocale(const Locale('en'));
                        controller.saveLocale();
                      }
                    },
                  ),
                ),
                GetBuilder<LanguageController>(
                  init: LanguageController(),
                  builder: (controller) => CheckboxListTile(
                    checkColor: Colors.white,
                    activeColor: const Color(0xFFB97CFC),
                    title:  Text('arabe'.tr),
                    value: controller.savedLang.value == 'AR',
                    onChanged: (bool? value) {
                      if (value != null && value) {
                        controller.savedLang.value = 'AR';
                        Get.updateLocale(const Locale('ar'));
                        controller.saveLocale();
                      }
                    },
                  ),
                ),
                GetBuilder<LanguageController>(
                  init: LanguageController(),
                  builder: (controller) => CheckboxListTile(
                    checkColor: Colors.white,
                    activeColor: const Color(0xFFB97CFC),
                    title:  Text('francais'.tr),
                    value: controller.savedLang.value == 'FR',
                    onChanged: (bool? value) {
                      if (value != null && value) {
                        controller.savedLang.value = 'FR';
                        Get.updateLocale(const Locale('fr'));
                        controller.saveLocale();
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
