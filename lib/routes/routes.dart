import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:tsdoha/views/home/home_screen.dart';
import 'package:tsdoha/views/login/login_screen.dart';
import 'package:tsdoha/views/mymessages/mymessage_screen.dart';

import 'package:tsdoha/views/onbording/spalsh_screen.dart';

import '../getx_controller_binding.dart';

class Routes {
  static String loginscreen = "/loginscreen";
  static String getloginscreen() => loginscreen;

  static String home = "/home";
  static String gethomescreen() => home;

  static String messagescreen = "/message";
  static String getmessagescreen() => messagescreen;

  static String splashscreen = "/splash";
  static String getspalsh() => splashscreen;

  static List<GetPage> routes = [
    GetPage(
      name: loginscreen,
      page: () => const LoginScreen(),
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
    GetPage(
      name: splashscreen,
      page: () => const SplashScreen(),
      binding: ControllersBinding(),
    ),
  ];
}
