import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:tunisian_school_doha/views/home/home_screen.dart';
import 'package:tunisian_school_doha/views/login/login_screen.dart';
import 'package:tunisian_school_doha/views/mymessages/mymessage_screen.dart';
import 'package:tunisian_school_doha/views/onbording/onbording_screen.dart';

import '../getx_controller_binding.dart';

class Routes {
  static String onbording = "/";
  static String getonbording() => onbording;

  static String loginscreen = "/loginscreen";
  static String getloginscreen() => loginscreen;

  static String home = "/home";
  static String gethomescreen() => home;

  static String messagescreen = "/message";
  static String getmessagescreen() => messagescreen;

  static List<GetPage> routes = [
    GetPage(
      name: onbording,
      page: () => const OnboardingScreen(),
      binding: ControllersBinding(),
    ),
    GetPage(
      name: loginscreen,
      page: () => LoginScreen(),
      binding: ControllersBinding(),
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(),
      binding: ControllersBinding(),
    ),
    GetPage(
      name: messagescreen,
      page: () => MessagesScreen(),
      binding: ControllersBinding(),
    ),
  ];
}
