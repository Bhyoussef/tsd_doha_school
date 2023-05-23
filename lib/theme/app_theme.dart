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



class PadiwanButtonTheme {
  const PadiwanButtonTheme._();

  static TextButtonThemeData get whiteButtonTheme => TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(
          AppColor.primaryBlueColor.withOpacity(0.35),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            )),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ));

  static TextButtonThemeData get blueButtonTheme => TextButtonThemeData(
      style: whiteButtonTheme.style!.copyWith(
          overlayColor: MaterialStateProperty.all<Color>(
            Colors.white.withOpacity(0.35),
          ),
          foregroundColor:
          MaterialStateProperty.all<Color>(AppColor.primaryBlueColor),
          backgroundColor:
          MaterialStateProperty.all<Color>(AppColor.primaryBlueColor)));

  static TextButtonThemeData get redButtonTheme => TextButtonThemeData(
      style: whiteButtonTheme.style!.copyWith(
          overlayColor: MaterialStateProperty.all<Color>(
            Colors.white.withOpacity(0.35),
          ),
          foregroundColor:
          MaterialStateProperty.all<Color>(AppColor.primaryRedColor),
          backgroundColor:
          MaterialStateProperty.all<Color>(AppColor.primaryRedColor)));
}

