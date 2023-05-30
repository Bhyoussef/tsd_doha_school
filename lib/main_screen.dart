import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tunisian_school_doha/theme/app_colors.dart';
import 'controller/home_controller.dart';
import 'controller/auth_controller/login_controller.dart';

class MainScreen extends StatelessWidget {
  final HomeController controller = Get.find();

  MainScreen({super.key});

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
            title: Text(
              'mychildren'.tr,
              style: TextStyle(
                color: controller.getOptionColor(0),

              ),
            ),
            onTap: () {
              controller.getOptionColor(0);
              controller.updateSelectedOption(DrawerOption.MyChildren);
              controller.pageTitle.value = 'mychildren'.tr;
              controller.pageTitle.value;
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: Text(
              'mymessage'.tr,
              style: TextStyle(
                color: controller.getOptionColor(1),
              ),
            ),
            onTap: () {
              controller.getOptionColor(1);
              controller.updateSelectedOption(DrawerOption.MyMessages);
              controller.pageTitle.value = 'mymessage'.tr;
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: Text(
              'mypayments'.tr,
              style: TextStyle(
                color: controller.getOptionColor(2),
              ),
            ),
            onTap: () {
              controller.getOptionColor(2);
              controller.updateSelectedOption(DrawerOption.MyPayments);
              controller.pageTitle.value = 'mypayments'.tr;
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text('aboutus'.tr,
                style: TextStyle(color: controller.getOptionColor(3))),
            onTap: () {
              controller.getOptionColor(3);
              controller.updateSelectedOption(DrawerOption.About);
              controller.pageTitle.value = 'aboutus'.tr;
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text(
              'updatepassword'.tr,
              style: TextStyle(
                color: controller.getOptionColor(4),
              ),
            ),
            onTap: () {
              controller.getOptionColor(4);
              controller.updateSelectedOption(DrawerOption.UpdatePassword);
              controller.pageTitle.value = 'updatepassword'.tr;
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              'configuration'.tr,
              style: TextStyle(
                color: controller.getOptionColor(5),
              ),
            ),
            onTap: () {
              controller.getOptionColor(5);
              controller.updateSelectedOption(DrawerOption.Configuration);
              controller.pageTitle.value = 'configuration'.tr;
              Get.back();
            },
          ),
          ListTile(
            leading:  Icon(
              Icons.logout,
              color: primarycolor,
            ),
            title: Text(
              'logout'.tr,
              style:  TextStyle(
                  color: primarycolor, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Get.dialog(LogoutDialog());
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

   LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:  Text('logout'.tr),
      content: Obx(
        () => _authController.isLoading.value
            ?  CircularProgressIndicator(color: primarycolor,)
            :  Text('areyousureyouwanttologout'.tr),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Get.back(),
          child:  Text('cancel'.tr,style: TextStyle(color: primarycolor),),
        ),
        TextButton(
          onPressed: () {
            _authController.logout();
            Get.back();
          },
          child:  Text('logout'.tr,style: TextStyle(color: primarycolor)),
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
