import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class DiciplineScreen extends StatelessWidget {
  const DiciplineScreen({Key? key}) : super(key: key);

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
        title: const Text('Dicipline',style: TextStyle(
            color: Color(0xFF7590d6)
        ),),
      ),
    );
  }
}
