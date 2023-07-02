import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/model/auth_model.dart';
import 'package:tsdoha/utils/shared_preferences.dart';
import 'package:tsdoha/views/home/home_screen.dart';
import 'package:tsdoha/views/mymessages/mymessage_screen.dart';

enum DrawerOption {
  MyChildren,
  MyMessages,
  MyPayments,
  About,
  UpdatePassword,
  Configuration,
  Logout,
}

class HomeController extends GetxController {
  var selectedOption = DrawerOption.MyChildren.obs;
  var pageTitle = "mychildren".tr.obs;

  late Result parent;

  void goToMyChildrenScreen() {
    selectedOption.value = DrawerOption.MyChildren;
    pageTitle.value = 'My Children';
    Get.offAll(() => HomeScreen()); // Use Get.offAll instead of Get.to to remove all previous routes
  }
  void goToMessageScreen() {
    selectedOption.value = DrawerOption.MyMessages;
    pageTitle.value = 'My Messages';
    Get.offAll(() => MessagesScreen()); // Use Get.offAll instead of Get.to to remove all previous routes
  }

  @override
  void onInit() {
    super.onInit();
    SharedData.getFromStorage('parent', 'string').then((parentData) async {
      parent = Result.fromJson(jsonDecode(parentData));
    });
  }

  void updateSelectedOption(DrawerOption option) {
    selectedOption.value = option;
    updateTitle(option); // Update the page title
    Get.back(); // Close the drawer after selecting an option
  }

  Color getOptionColor(DrawerOption option) {
    return selectedOption.value == option
        ? const Color(0xFF590D6F)
        : Colors.black;
  }

  void updateTitle(DrawerOption option) {
    switch (option) {
      case DrawerOption.MyChildren:
        pageTitle.value = "mychildren".tr;
        break;
      case DrawerOption.MyMessages:
        pageTitle.value = "mymessage".tr;
        break;
      case DrawerOption.MyPayments:
        pageTitle.value = "mypayments".tr;
        break;
      case DrawerOption.About:
        pageTitle.value = "aboutus".tr;
        break;
      case DrawerOption.UpdatePassword:
        pageTitle.value = "updatepassword".tr;
        break;
      case DrawerOption.Configuration:
        pageTitle.value = "configuration".tr;
        break;
      case DrawerOption.Logout:
        pageTitle.value = "";
        break;
      default:
        pageTitle.value = "mychildren".tr;
        break;
    }
  }
}
