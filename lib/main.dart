import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'languages/translation.dart';
import 'routes/routes.dart';
import 'theme/app_theme.dart';
import 'utils/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId("af23d587-573e-4f0c-837a-e8c0c19ec76e");
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  app();

}

void app() async {
  final language = await SharedData.getFromStorage('language', 'string');
  if (kDebugMode) {
    print('Language saved : == $language');
  }
  if (language != null) {
    final parent = await SharedData.getFromStorage('parent', 'string');
    if (parent != null) {
      final uid = await SharedData.getFromStorage('parent', 'object', 'uid');
      if (uid != null) {
        runApp(
          MyApp(route: Routes.home, language: language),
        );
        return;
      }
    }
    runApp(
      MyApp(route: Routes.loginScreen, language: language),
    );
  }

  runApp(
    MyApp(route: Routes.splashScreen, language: 'en'),
  );
}

class MyApp extends StatelessWidget {
  final String? route;
  final String? language;

  const MyApp({
    Key? key,
    this.route,
    this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: appThemeData(context),
      translations: Translation(),
      locale: language == 'ar'
          ? const Locale('ar', 'AR')
          : const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      initialRoute: route,
      getPages: Routes.routes,
    );
  }
}
