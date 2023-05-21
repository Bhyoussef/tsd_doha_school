import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RecordingScreen extends StatelessWidget {
  const RecordingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Color(0xFFB97CFC),),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        title: const Text('Recording',style: TextStyle(
            color: Color(0xFF7590d6)
        ),),
      ),
    );
  }
}
