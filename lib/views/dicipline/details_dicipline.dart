import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tsdoha/model/dicipline_model.dart';
import 'package:tsdoha/routes/routes.dart';
import 'package:tsdoha/theme/app_colors.dart';

class DiciplineDetail extends StatelessWidget {
  final Dicipline? dicipline;
  const DiciplineDetail(this.dicipline, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: CupertinoColors.white),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: primarycolor,
        title: Text(
          'discipline'.tr,
          style: const TextStyle(
            color: CupertinoColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(Routes.home);
              },
              child: Image.asset(
                'assets/imgs/tsdIcon.png',
                width: 40,
                height: 40,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: ListView(
            shrinkWrap: true,
            children: [
              ChildCardPayment(dicipline: dicipline),
              SizedBox(height: 10,),
              DiciplineCard(dicipline: dicipline)
            ],
          ),
        ),
      ),
    );
  }
}

class ChildCardPayment extends StatelessWidget {
  final Dicipline? dicipline;

  const ChildCardPayment({Key? key, this.dicipline}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Get.locale;
    final isArabic = locale?.languageCode == 'ar';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: _buildCircleAvatar(dicipline!.teacherImage!),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '${dicipline!.teacher! ?? ''}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCircleAvatar(dynamic image) {
  if (image is String && image.isNotEmpty) {
    return Image.memory(
      base64Decode(image),
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        print('Error loading user avatar');
        return CircleAvatar(
          backgroundImage: AssetImage('assets/imgs/user.png'),
          radius: 30.0,
        );
      },
    );
  }

  return CircleAvatar(
    backgroundImage: AssetImage('assets/imgs/user.png'),
    radius: 30.0,
  );
}

class DiciplineCard extends StatelessWidget {
  final Dicipline? dicipline;

  const DiciplineCard({
    Key? key,
    this.dicipline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Get.locale;
    final isArabic = locale?.languageCode == 'ar';
    bool isMessageRead = dicipline!.state! == 'read';
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      dicipline!.typeOfSanction!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      dicipline!.student!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16.0, color: Colors.black),
                    children: [
                      TextSpan(
                        text: dicipline!.messageOfSanction!,
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse( dicipline!.date!,)
                          .add(Duration(hours: 3))),
                      style: const TextStyle(fontSize: 14.0),
                    ),

                  ],
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
