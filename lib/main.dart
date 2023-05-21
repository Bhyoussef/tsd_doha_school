import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tunisian_school_doha/routes/routes.dart';
import 'package:tunisian_school_doha/theme/app_theme.dart';
import 'package:tunisian_school_doha/utils/shared_preferences.dart';
import 'languages/translation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app();
}

void app() async {
  final language = await SharedData.getFromStorage('language', 'string');
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
  }

  runApp(
    MyApp(route: Routes.onbording, language: language),
  );
}


class MyApp extends StatelessWidget {
  final String? route;
  final String? language;

  const MyApp({
    Key? key,
    this.route,  this.language,
  }) : super(key: key);

  Future<String?> _getLanguage() async {
    final language = await SharedData.getFromStorage('language', 'string');
    return language;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getLanguage(),
      builder: (context, snapshot) {
        final savedLanguage = snapshot.data;
        final locale = savedLanguage != null ? Locale(savedLanguage) : null;
        return GetMaterialApp(
          theme: appThemeData(context),
          translations: Translation(),
          locale: locale,
          debugShowCheckedModeBanner: false,
          initialRoute: route,
          getPages: Routes.routes,
        );
      },
    );
  }
}



