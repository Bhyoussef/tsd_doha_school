import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/language_controller/language_controller.dart';
import '../../controller/auth_controller/login_controller.dart';
import 'password_rsest_screen.dart';
import 'widget/login_text_field_widget.dart';

class LoginScreen extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController(text: '27178800234');
  final _passwordController = TextEditingController(text: '1234');

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.black,
      ),
   /*   appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GetBuilder<LanguageController>(
              init: LanguageController(),
              builder: (value) {
                return DropdownButton<String>(
                  dropdownColor: Colors.white,
                  value: value.savedLang.value,
                  icon: const Icon(
                    Icons.language_outlined,
                    size: 20,
                    color: Colors.black,
                  ),
                  elevation: 16,
                  style: const TextStyle(color: Colors.white),
                  underline: Container(
                    height: 1,
                    color: Colors.white,
                  ),
                  onChanged: (String? newValue) {
                    value.savedLang.value = newValue!;
                    Get.updateLocale(Locale(newValue.toLowerCase()));
                    value.saveLocale();
                  },
                  items:
                      <String>['EN', 'AR', 'FR'].map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    },
                  ).toList(),
                );
              },
            ),
          ),
        ],
      ),*/
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Image.asset(
                  'assets/imgs/logotsd.png',
                  height: 150,
                ),
                const SizedBox(height: 40),
                LoginTextField(
                  controller: _loginController,
                  labelText: 'parent_id'.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'parent_id_required'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                LoginTextField(
                  controller: _passwordController,
                  labelText: 'password'.tr,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'password_obligatoire'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  minWidth: 380,
                  color: const Color(0xFFB97CFC),
                  textColor: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _authController.authenticateUser(
                        _loginController.text,
                        _passwordController.text,
                      );
                    }
                  },
                  child: Text('identifier'.tr),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Get.to(PasswordResetScreen()),
                  child: Text(
                    'reset_password'.tr,
                    style: TextStyle(color: Color(0xFF7590d6)),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => _authController.isLoading.value
                    ? const CircularProgressIndicator()
                    : Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
