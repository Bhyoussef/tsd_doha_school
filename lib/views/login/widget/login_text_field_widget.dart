import 'package:flutter/material.dart';


class LoginTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final bool obscureText;
  final String? Function(String?)? validator;

  const LoginTextField({
     this.controller,
     this.labelText,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      validator: validator,
    );
  }
}