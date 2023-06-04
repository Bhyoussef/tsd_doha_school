import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:tsdoha/model/child_model.dart';
import 'package:tsdoha/views/about/about_screen.dart';
import 'package:tsdoha/views/configuration/configuration_screen.dart';
import 'package:tsdoha/views/excersice/excersice_screen.dart';
import 'package:tsdoha/views/home/home_screen.dart';
import 'package:tsdoha/views/login/login_screen.dart';
import 'package:tsdoha/views/mymessages/mymessage_screen.dart';
import 'package:tsdoha/views/onbording/spalsh_screen.dart';
import '../getx_controller_binding.dart';
import '../views/dicipline/dicipline_screen.dart';
import '../views/mychildren/children_details_screen.dart';
import '../views/mychildren/mychildren_screen.dart';

class Routes {
  static String loginScreen = "/login";
  static String getloginscreen() => loginScreen;

  static String home = "/home";
  static String getHomeScreen() => home;

  static String messageScreen = "/message";
  static String getMessageScreen() => messageScreen;

  static String splashScreen = "/splash";
  static String getSpalsh() => splashScreen;

  static String myChildren = "/mychildren";
  static String getMyChildren() => myChildren;

  static String childDetail = "/childdetail";
  static String getChildDetail(Mychildreen student) => childDetail;


  static String aboutScreen = "/about";
  static String getAbout() => aboutScreen;

  static String settingsScreen = "/about";
  static String getSettingScreen() => settingsScreen;

  static String deciplineScreen = "/dicipline";
  static String getDiciplineScreen() => deciplineScreen;


  static String exerciseScreen = "/exercise";
  static String getExercise() => exerciseScreen;

  static List<GetPage> routes = [
    GetPage(
      name: loginScreen,
      page: () => const LoginScreen(),
      binding: ControllersBinding(),
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(),
      binding: ControllersBinding(),
    ),
    GetPage(
      name: messageScreen,
      page: () => const MessagesScreen(),
      binding: ControllersBinding(),
    ),
    GetPage(
      name: splashScreen,
      page: () =>  const SplashScreen(),
      binding: ControllersBinding(),
    ),
    GetPage(
      name: myChildren,
      page: () =>  MyChildrenScreen(),
      binding: ControllersBinding(),
    ),
    GetPage(
      name: childDetail,
      page: () =>  const DetailScreen(),
      binding: ControllersBinding(),
    ),
    GetPage(
      name: aboutScreen,
      page: () => const AboutScreen(),
      binding: ControllersBinding(),
    ),
    GetPage(
      name: settingsScreen,
      page: () => const SettingsScreen(),
      binding: ControllersBinding(),
    ),
    GetPage(
      name: deciplineScreen,
      page: () => const DiciplineScreen(),
      binding: ControllersBinding(),
    ),
    GetPage(
      name: exerciseScreen,
      page: () => const ExerciseScreen(),
      binding: ControllersBinding(),
    ),
  ];
}
