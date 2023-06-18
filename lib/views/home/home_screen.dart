import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:tsdoha/controller/home_controller.dart';
import 'package:tsdoha/main_screen.dart';
import 'package:tsdoha/services/auth.dart';
import 'package:tsdoha/theme/app_colors.dart';
import 'package:tsdoha/utils/shared_preferences.dart';
import 'package:tsdoha/views/about/about_screen.dart';
import 'package:tsdoha/views/configuration/configuration_screen.dart';
import 'package:tsdoha/views/mychildren/mychildren_screen.dart';
import 'package:tsdoha/views/mymessages/mymessage_screen.dart';
import 'package:tsdoha/views/mypayments/mypayment_screen.dart';
import 'package:tsdoha/views/updatepassword/updatepassword_screen.dart';


class HomeScreen extends StatefulWidget {

  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());




  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('exitconfirmation'.tr,style:TextStyle(color: primarycolor)),
          content: Text('doyouwanttoexit'.tr),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('no'.tr,style: TextStyle(color: primarycolor),),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('yes'.tr,style: TextStyle(color: primarycolor),),
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  void initState()  {
    pushId();
    super.initState();
  }

  void pushId()async {
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    final uid = await SharedData.getFromStorage('parent', 'object', 'uid');
    final push = await ApiServiceAuth.pushData(osUserID!, uid);



    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('hereeeeeeeee'+result.notification.additionalData?['alert']);
      print('hereeeeeeeee'+result.notification.additionalData?['title']);
    });




 /*   OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      final notificationData = result.notification.jsonRepresentation();
      print('noitication opened${notificationData}');
      this.setState(() {
      final parsedData = jsonDecode(notificationData) as Map<String, dynamic>;
      print('data parsed hhhhhhhhhhhhhhhhhh${parsedData}');
      final notificationTitle = parsedData['alert'];
      final notificationBody = parsedData['title'];
      print('Alert: $notificationTitle');
      print('Title: $notificationBody');
      });
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.transparent,
          backgroundColor: primarycolor,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Obx(() => Text(
            controller.pageTitle.value,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontWeight: FontWeight.bold,
            ),
          )),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                 controller.goToMyChildrenScreen();
                },
                child: Image.asset(
                  'assets/imgs/tsdIcon.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ],
        ),
        drawer: MainScreen(),
        body: Obx(() {
          switch (controller.selectedOption.value) {
            case DrawerOption.MyChildren:
              return MyChildrenScreen();
            case DrawerOption.MyMessages:
              return const MessagesScreen();
            case DrawerOption.MyPayments:
              return MyPaymentsScreen();
            case DrawerOption.About:
              return const AboutScreen();
            case DrawerOption.UpdatePassword:
              return UpdatePasswordScreen();
            case DrawerOption.Configuration:
              return const SettingsScreen();
            default:
              return MyChildrenScreen();
          }
        }),
      ),
    );
  }
}
