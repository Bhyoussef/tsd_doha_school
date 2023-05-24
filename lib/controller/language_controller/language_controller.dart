import 'dart:ui';
import 'package:get/get.dart';
import 'package:tunisian_school_doha/utils/shared_preferences.dart';

class LanguageController extends GetxController {
  var savedLang = "EN".obs;

  Future<void> changeLanguage(language) async {
    SharedData.saveToStorage('language', language, 'string');
    Get.updateLocale(Locale(language.toString().toLowerCase()));
    savedLang.value = language.toString();
    update();
  }

  @override
  void onInit() async {
    final language = await SharedData.getFromStorage('language', 'string');
    changeLanguage(language);
    super.onInit();
  }
}
