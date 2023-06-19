import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/model/child_model.dart';

class ChildCardPayment extends StatelessWidget {
  final Mychildreen student;

  const ChildCardPayment({Key? key, required this.student}) : super(key: key);

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
          _buildCircleAvatar(student.image),
          const SizedBox(width: 10),
          Text(
            isArabic?'${student.nameAr ?? ''} ${student.lastNameAr ?? ''}': '${student.name ?? ''} ${student.lastName ?? ''}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCircleAvatar(dynamic image) {
    if (image != null) {
      try {
        final decodedImage = base64Decode(image.toString());
        final imageBytes = Uint8List.fromList(decodedImage);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: MemoryImage(imageBytes),
            radius: 30.0,
          ),
        );
      } catch (e) {
        print('Invalid image data: $e');
      }
    }
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundImage: AssetImage("assets/imgs/user-avatar.png"),
        radius: 30.0,
      ),
    );
  }
}