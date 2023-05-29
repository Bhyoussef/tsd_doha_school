import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                'assets/imgs/logo.png',
                height: 200,
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  launch('https://proosoftcloud.com/');
                },
                child:  ListTile(
                  leading: const Icon(Icons.language),
                  title: Text('website'.tr),
                ),
              ),
              GestureDetector(
                onTap: () {
                  launch('info@proosoft.com');
                },
                child:  ListTile(
                  leading: const Icon(Icons.email),
                  title: Text('email'.tr),
                ),
              ),
              GestureDetector(
                onTap: () {
                  launch(
                      'https://www.facebook.com/Proo-School-Erp-102552524734673/');
                },
                child:  ListTile(
                  leading: const Icon(Icons.facebook),
                  title: Text('facebook'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
