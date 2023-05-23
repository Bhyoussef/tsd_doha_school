import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../model/child_model.dart';

class ChildCardWidget extends StatelessWidget {
  final Mychildreen student;

  const ChildCardWidget({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, right: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    student.group ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    student.Class ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildCircleAvatar(student.image),
                const SizedBox(height: 10),
                Text(
                  '${student.nameAr ?? ''} ${student.lastNameAr ?? ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${student.name ?? ''} ${student.lastName ?? ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
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

        return CircleAvatar(
          backgroundImage: MemoryImage(decodedImage),
          radius: 40.0,
        );
      } catch (e) {

        print('Invalid image data: $e');
      }
    }
    return const CircleAvatar(
     backgroundImage: AssetImage('assets/imgs/user-avatar.png'),
      radius: 40.0,
    );
  }

}
