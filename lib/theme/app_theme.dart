import '../theme/app_colors.dart';
import 'package:flutter/material.dart';

ThemeData appThemeData(BuildContext context) {
  return ThemeData(
    primaryColor: buttonBlue,
    inputDecorationTheme: inputDecorationTheme(),
    fontFamily: 'bahij',
    colorScheme: Theme.of(context)
        .colorScheme
        .copyWith(primary: buttonBlue)
        .copyWith(secondary: buttonBlue),
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(color: greyText),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}
