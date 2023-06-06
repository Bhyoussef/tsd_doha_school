import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main_screen.dart';
import '../../controller/home_controller.dart';
import '../../theme/app_colors.dart';
import '../about/about_screen.dart';
import '../configuration/configuration_screen.dart';
import '../mychildren/mychildren_screen.dart';
import '../mymessages/mymessage_screen.dart';
import '../mypayments/mypayment_screen.dart';
import '../updatepassword/updatepassword_screen.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomeScreen({Key? key}) : super(key: key);

  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit Confirmation',style:TextStyle(color: primarycolor)),
          content: Text('Are you sure you want to exit the application?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No',style: TextStyle(color: primarycolor),),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes',style: TextStyle(color: primarycolor),),
            ),
          ],
        );
      },
    ) ?? false;
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
                 Get.to(()=>HomeScreen());
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
