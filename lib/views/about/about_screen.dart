import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Column(
            children: [
              SizedBox(
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
                child: ListTile(
                  leading: const Icon(Icons.language),
                  title: Text('website'.tr),
                ),
              ),
              GestureDetector(
                onTap: () {
                  launch('mailto:wch@gmail.com');
                },
                child: ListTile(
                  leading: const Icon(Icons.email),
                  title: Text('email'.tr),
                ),
              ),
              GestureDetector(
                onTap: () {
                  launch(
                      'https://www.facebook.com/Proo-School-Erp-102552524734673/');
                },
                child: ListTile(
                  leading: const Icon(Icons.facebook),
                  title: Text('facebook'.tr),
                ),
              ),
            ],
          )),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Image.asset(
                    'assets/imgs/linkialogo.png',
                    height: 35,
                  ),
                  GestureDetector(
                    onTap: () {
                      launch('https://linkia.qa');
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'devloppedby'.tr,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'linkia'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff318fd2),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
