import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller/password_rest_controller.dart';

class PasswordResetScreen extends StatelessWidget {
  final controller = Get.put(PasswordResetController());

  PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF6495ed),
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
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
              SizedBox(height: 40),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'parent_id'.tr,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              MaterialButton(
                minWidth: 380,
                color: Color(0xFFB97CFC),
                onPressed: () {},
                textColor: Colors.white,
                child: Text('reset_password'.tr),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  'or_login'.tr,
                  style: const TextStyle(color: Color(0xFF7590d6)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
