import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/constant/constant.dart';
import 'package:tsdoha/controller/auth_controller/login_controller.dart';
import 'package:tsdoha/views/login/password_reset.dart';
import '../../theme/app_colors.dart';
import '../../utils/keyboard.dart';
import 'widget/BottomTextureOnly.dart';
import 'widget/login_text_field_widget.dart';
import 'widget/top_red_section_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: () => KeyboardUtil.hideKeyboard(context),
        child: Container(
          color: Colors.white,
          child: Form(
            key: authController.loginFormKey,
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
                                      controller:
                                          authController.loginController.value,
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
                                      controller: authController
                                          .passwordController.value,
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
                                        if (authController
                                            .loginFormKey.currentState!
                                            .validate()) {
                                          authController.authenticateUser(
                                            authController
                                                .loginController.value.text,
                                            authController
                                                .passwordController.value.text,
                                          );
                                        }
                                      },
                                      child: Text('identifier'.tr),
                                    ),
                                    const SizedBox(height: 18),
                                    TextButton(
                                      onPressed: () => Get.to(
                                        PasswordRest(),
                                        transition: Transition.fade,
                                        duration: const Duration(seconds: 1),
                                      ),
                                      child: Text(
                                        'reset_password'.tr,
                                        style: TextStyle(
                                          color: primarycolor,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Obx(() => authController.isLoading.value
                                        ? Center(
                                            child: CircularProgressBar(
                                            color: primarycolor,
                                          ))
                                        : Container())
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
