import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tunisian_school_doha/theme/app_colors.dart';
import 'package:tunisian_school_doha/views/login/password_rsest_screen.dart';
import 'package:tunisian_school_doha/views/login/widget/login_text_field_widget.dart';
import '../../controller/auth_controller/login_controller.dart';
import '../../utils/keyboard.dart';
import 'widget/BottomTextureOnly.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController _authController = Get.put(AuthController());
    final size = MediaQuery.of(context).size;
    final _formKey = GlobalKey<FormState>();
    final _loginController = TextEditingController(text: '27178800234');
    final _passwordController = TextEditingController(text: '1234');

    return Scaffold(
      body: GestureDetector(
        onTap: () => KeyboardUtil.hideKeyboard(context),
        child: Container(
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: BottomTextureOnly(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TopRedSection(
                            size: size,
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 28),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 50),
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
                                    const SizedBox(height: 18),
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
                                    const SizedBox(height: 18),
                                    MaterialButton(
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      height: 50,
                                      color: primarycolor,
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
                                    const SizedBox(height: 18),
                                    TextButton(
                                      onPressed: () =>
                                          Get.to(PasswordResetScreen()),
                                      child: Text(
                                        'reset_password'.tr,
                                        style: TextStyle(color: primarycolor),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Obx(() => _authController.isLoading.value
                                        ? const CircularProgressIndicator()
                                        : Container()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TopRedSection extends StatelessWidget {
  final Size size;

  const TopRedSection({super.key, required this.size});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Container(
        color: primarycolor,
        height: 380,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 55,
              height: 389 / 2.3,
              child: SizedBox(
                height: 156,
                width: 156,
                child: Image.asset('assets/imgs/logotsd.png'),
              ),
            ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/imgs/loginBackground.png',
                    width: size.width,
                    alignment: Alignment.bottomCenter,
                    height: 165,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
