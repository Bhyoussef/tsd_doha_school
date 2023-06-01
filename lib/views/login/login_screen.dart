import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../controller/auth_controller/login_controller.dart';
import '../../theme/app_colors.dart';
import '../../utils/keyboard.dart';
import 'password_reset.dart';
import 'widget/BottomTextureOnly.dart';
import 'widget/login_text_field_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    final size = MediaQuery.of(context).size;
    final formKey = GlobalKey<FormState>();
    final loginController = TextEditingController(text: '27178800234');
    final passwordController = TextEditingController(text: '1234');

    return Scaffold(
      body: GestureDetector(
        onTap: () => KeyboardUtil.hideKeyboard(context),
        child: Container(
          color: Colors.white,
          child: Form(
            key: formKey,
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
                                      controller: loginController,
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
                                      controller: passwordController,
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
                                        if (formKey.currentState!.validate()) {
                                          authController.authenticateUser(
                                            loginController.text,
                                            passwordController.text,
                                          );
                                        }
                                      },
                                      child: Text('identifier'.tr),
                                    ),
                                    const SizedBox(height: 18),
                                    TextButton(
                                      onPressed: () =>
                                          Get.to(PasswordRest()),
                                      child: Text(
                                        'reset_password'.tr,
                                        style: TextStyle(color: primarycolor),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Obx(() => authController.isLoading.value
                                        ?  CircularProgressBar(color: primarycolor,)
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
  final Size? size;

  const TopRedSection({super.key,  this.size});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Container(
        color: primarycolor,
        height: 350,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 100,
              child: Column(
                children: [
                  SizedBox(
                    height: 156,
                    width: 156,
                    child: Image.asset('assets/imgs/tsdIcon.png'),
                  ),
                  const Text(
                    'Tunisian School',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontFamily: 'Bahij',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
