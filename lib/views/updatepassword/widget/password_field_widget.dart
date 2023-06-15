import 'package:flutter/material.dart';

class PasswordFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardtype;
  final FormFieldValidator<String>? validator;

  const PasswordFormField({super.key,
    required this.controller,
    required this.labelText,
    required this.keyboardtype,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardtype,
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      validator: validator,
    );
  }
}