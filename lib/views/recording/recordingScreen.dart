import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tunisian_school_doha/theme/app_colors.dart';


class RecordingScreen extends StatelessWidget {
  const RecordingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: CupertinoColors.white,),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: primarycolor,
        title: const  Text('Recording',style: TextStyle(
            color: CupertinoColors.white,fontWeight: FontWeight.bold
        ),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/imgs/notfound.png'),
            Text('No Records Found ')
          ],
        )
      ),
    );
  }
}
