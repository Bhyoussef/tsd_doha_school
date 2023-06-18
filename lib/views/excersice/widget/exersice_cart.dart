import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/exersice_model.dart';

class ExerciseCard extends StatelessWidget {
  final Exersice? exercise;

  ExerciseCard(
      this.exercise, {
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Get.locale;
    final isArabic = locale?.languageCode == 'ar';
    bool isMessageRead = exercise!.state! == 'read';
    bool isAttached =exercise!.attachmentId!.isEmpty;
    return Container(
      decoration:  BoxDecoration(
        color: isMessageRead ? Colors.white : Color(0xffececec),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  exercise!.titleOfHomework!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ClipOval(child: _buildCircleAvatar(exercise!.teacherImage!)),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        exercise!.teacher!,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      exercise!.date!,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          isArabic == true
              ? Positioned(
            top: 8.0,
            left: 8.0,
            child: Container(
              width: 12.0,
              height: 12.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isMessageRead ? Colors.green : Colors.red,
              ),
            ),
          )
              : Positioned(
            top: 8.0,
            right: 8.0,
            child: Container(
              width: 12.0,
              height: 12.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isMessageRead ? Colors.green : Colors.red,
              ),
            ),
          ),
          isAttached!
              ? Container()
              : isArabic == true
              ? const Positioned(
            top: 8.0,
            left: 25.0,
            child: Icon(Icons.attach_file),
          )
              : const Positioned(
            top: 8.0,
            right: 25.0,
            child: Icon(Icons.attach_file),
          ),
        ],
      ),
    );
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







}