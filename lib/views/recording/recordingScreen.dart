import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/routes.dart';
import '../../theme/app_colors.dart';



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
        title:   Text('recording'.tr,style: const TextStyle(
            color: CupertinoColors.white,fontWeight: FontWeight.bold
        ),),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/imgs/notfound.png'),
             Text('norecords'.tr)
          ],
        )
      ),
    );
  }
}
