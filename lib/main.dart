import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'languages/translation.dart';
import 'routes/routes.dart';
import 'theme/app_theme.dart';
import 'utils/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  // SharedData.clearStorage();
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
      MyApp(route: Routes.loginscreen, language: language),
    );
  }

  runApp(
    MyApp(route: Routes.splashscreen, language: 'en'),
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
