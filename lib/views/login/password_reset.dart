import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/constant/constant.dart';
import 'package:tsdoha/controller/auth_controller/password_rest_controller.dart';
import 'package:tsdoha/theme/app_colors.dart';
import 'package:tsdoha/utils/keyboard.dart';
import 'widget/BottomTextureOnly.dart';
import 'widget/top_red_section_widget.dart';

class PasswordRest extends StatelessWidget {

  PasswordRest({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PasswordResetController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => KeyboardUtil.hideKeyboard(context),
        child: Container(
          color: Colors.white,
          child: Form(
            key: controller.resetform,
            child: Column(
              children: [
                Expanded(
                  child: BottomTextureOnly(
                    child: SingleChildScrollView(
                      child: Form(
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
                                      TextFormField(
                                        controller: controller.restfield.value,
                                        decoration: InputDecoration(
                                            labelText: 'parent_id'.tr,
                                            border:  OutlineInputBorder(),
                                            labelStyle: TextStyle(
                                                color: primarycolor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        cursorColor: primarycolor,

                                      ),
                                      const SizedBox(height: 18),
                                      MaterialButton(
                                        height: 50,
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        color: primarycolor,
                                        onPressed: () {
                                          controller.updatePasswd(
                                            int.parse(controller.restfield.value.text),
                                          );
                                          print(int.parse(controller.restfield.value.text));
                                        },
                                        textColor: Colors.white,
                                        child: Text('reset_password'.tr),
                                      ),
                                      const SizedBox(height: 18),
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text(
                                          'or_login'.tr,
                                          style: TextStyle(
                                              color: primarycolor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Obx(() => controller.isLoading.value
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
