import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tsdoha/theme/app_colors.dart';
import 'package:tsdoha/controller/home_controller.dart';
import 'package:tsdoha/controller/auth_controller/login_controller.dart';

import 'constant/constant.dart';

class MainScreen extends StatelessWidget {
  final HomeController controller = Get.find();

  MainScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 240,
            decoration: BoxDecoration(
              gradient:  LinearGradient(
                colors: [primarycolor, primarycolor],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: MemoryImage(
                    base64Decode(controller.parent.image ?? ''),
                  ),
                  radius: 30.0,
                ),
                const SizedBox(height: 10),
                Text(
                  controller.parent.userMobileName.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Obx(() => Text(
              'mychildren'.tr,
              style: TextStyle(
                color: controller.getOptionColor(DrawerOption.MyChildren),
              ),
            )),
            onTap: () {
              controller.updateSelectedOption(DrawerOption.MyChildren);
              controller.updateTitle(DrawerOption.MyChildren);
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: Obx(() => Text(
              'mymessage'.tr,
              style: TextStyle(
                color: controller.getOptionColor(DrawerOption.MyMessages),
              ),
            )),
            onTap: () {
              controller.updateSelectedOption(DrawerOption.MyMessages);
              controller.updateTitle(DrawerOption.MyMessages);
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: Obx(() => Text(
              'mypayments'.tr,
              style: TextStyle(
                color: controller.getOptionColor(DrawerOption.MyPayments),
              ),
            )),
            onTap: () {
              controller.updateSelectedOption(DrawerOption.MyPayments);
              controller.updateTitle(DrawerOption.MyPayments);
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Obx(() => Text(
              'aboutus'.tr,
              style: TextStyle(
                color: controller.getOptionColor(DrawerOption.About),
              ),
            )),
            onTap: () {
              controller.updateSelectedOption(DrawerOption.About);
              controller.updateTitle(DrawerOption.About);
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: Obx(() => Text(
              'updatepassword'.tr,
              style: TextStyle(
                color: controller.getOptionColor(DrawerOption.UpdatePassword),
              ),
            )),
            onTap: () {
              controller.updateSelectedOption(DrawerOption.UpdatePassword);
              controller.updateTitle(DrawerOption.UpdatePassword);
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Obx(() => Text(
              'configuration'.tr,
              style: TextStyle(
                color: controller.getOptionColor(DrawerOption.Configuration),
              ),
            )),
            onTap: () {
              controller.updateSelectedOption(DrawerOption.Configuration);
              controller.updateTitle(DrawerOption.Configuration);
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: primarycolor,
            ),
            title: Text(
              'logout'.tr,
              style: TextStyle(
                  color: primarycolor, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Get.dialog(LogoutDialog());
              //Get.to(()=>FailedPayment());
            },
          ),
          Column(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () => _showQrImageDialog(
                        context, controller.parent.username!),
                    child: QrImageView(
                      data: controller.parent!.uid!.toString(),
                      version: QrVersions.auto,
                      foregroundColor: Colors.black,
                      size: 100.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                controller.parent.username.toString(),
                style: const TextStyle(color: Colors.black),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class LogoutDialog extends StatelessWidget {
  final AuthController _authController = Get.find();

  LogoutDialog({Key? key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'logout'.tr,
        style: TextStyle(color: primarycolor, fontWeight: FontWeight.bold),
      ),
      content: Obx(
            () => _authController.isLoading.value
            ? CircularProgressBar(color: primarycolor)
            : Text('areyousureyouwanttologout'.tr),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'cancel'.tr,
            style: TextStyle(color: primarycolor),
          ),
        ),
        TextButton(
          onPressed: () {
            _authController.logout();
            Get.back();
          },
          child: Text('logout'.tr, style: TextStyle(color: primarycolor)),
        ),
      ],
    );
  }
}

void _showQrImageDialog(BuildContext context, String qrData) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: qrData,
                version: QrVersions.auto,
                foregroundColor: Colors.black,
                size: 200.0,
              ),
              const SizedBox(height: 16.0),
              Text(
                qrData,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      );
    },
  );
}
