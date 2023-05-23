import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tunisian_school_doha/theme/app_colors.dart';
import 'widget/password_field_widget.dart';
import '../../controller/auth_controller/updatepassword_controller.dart';

class UpdatePasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final PasswordChangeController _passwordChangeController =
  Get.put(PasswordChangeController());

  final _oldpassword = TextEditingController();
  final _newpassword = TextEditingController();
  final _confirmpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                PasswordFormField(
                  controller: _oldpassword,
                  labelText: 'oldpassword'.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                PasswordFormField(
                  controller: _newpassword,
                  labelText: 'newpassword'.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                PasswordFormField(
                  controller: _confirmpassword,
                  labelText: 'confirmpassword'.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32.0),
                Center(
                  child: MaterialButton(
                    height: 50,
                    minWidth: MediaQuery.of(context).size.width,
                    color: primarycolor,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _passwordChangeController.updatePasswd(
                          _oldpassword.text,
                          _newpassword.text,
                          _confirmpassword.text,
                        );
                      }
                    },
                    child: Text(
                      'update'.tr,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                Obx(() => _passwordChangeController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

