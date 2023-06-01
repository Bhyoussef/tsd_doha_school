import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller/password_rest_controller.dart';
import '../../theme/app_colors.dart';
import '../../utils/keyboard.dart';
import 'widget/BottomTextureOnly.dart';

class PasswordRest extends StatelessWidget {
  final controller = Get.put(PasswordResetController());
   PasswordRest({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final _formKey = GlobalKey<FormState>();


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
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'parent_id'.tr,
                                        border: const OutlineInputBorder(),
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
                                        style:  TextStyle(color: primarycolor),
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
