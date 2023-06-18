import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller/password_rest_controller.dart';
import '../../theme/app_colors.dart';
import '../../utils/keyboard.dart';
import 'widget/BottomTextureOnly.dart';
import 'widget/top_red_section_widget.dart';

class PasswordRest extends StatelessWidget {
  final controller = Get.put(PasswordResetController());
  PasswordRest({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Colors.white,
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
                                    decoration: InputDecoration(
                                      labelText: 'parent_id'.tr,
                                      border: const OutlineInputBorder(),
                                      labelStyle: TextStyle(
                                        color: primarycolor,fontWeight: FontWeight.bold
                                      )
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  MaterialButton(
                                    height: 50,
                                    minWidth: MediaQuery.of(context).size.width,
                                    color: primarycolor,
                                    onPressed: () {},
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
                                      style: TextStyle(color: primarycolor,fontWeight: FontWeight.bold),
                                    ),
                                  ),
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
    );
  }
}
