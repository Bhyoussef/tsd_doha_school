import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/model/exersice_model.dart';

class TeacherCardPayment extends StatelessWidget {
  final Exersice? exercise;

  const TeacherCardPayment({Key? key, this.exercise}) : super(key: key);

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
            child: ClipOval(child: _buildCircleAvatar(exercise!.teacherImage!)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '${exercise!.teacher! ?? ''}',
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
          backgroundImage: AssetImage('assets/imgs/user-avatar.png'),
          radius: 30.0,
        );
      },
    );
  }

  return CircleAvatar(
    backgroundImage: AssetImage('assets/imgs/user-avatar.png'),
    radius: 30.0,
  );
}
