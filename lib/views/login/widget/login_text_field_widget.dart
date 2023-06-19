import 'package:flutter/material.dart';
import 'package:tsdoha/theme/app_colors.dart';


class LoginTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final bool obscureText;
  final String?
  Function(String?)? validator;
  const LoginTextField({super.key,
     this.controller,
     this.labelText,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: primarycolor,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: primarycolor,fontWeight: FontWeight.bold),
        border: const OutlineInputBorder(),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      validator: validator,
    );
  }
}