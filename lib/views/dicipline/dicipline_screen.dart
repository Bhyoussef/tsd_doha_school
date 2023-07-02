import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/constant/constant.dart';
import 'package:tsdoha/controller/mychildren_controller/mychildren_controller.dart';
import 'package:tsdoha/routes/routes.dart';
import 'package:tsdoha/theme/app_colors.dart';
import 'details_dicipline.dart';

class DiciplineScreen extends StatefulWidget {
  final int? studentId;
  DiciplineScreen({Key? key, this.studentId}) : super(key: key);

  @override
  State<DiciplineScreen> createState() => _DiciplineScreenState();
}

class _DiciplineScreenState extends State<DiciplineScreen> {
  final ChildrenController controller = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchdiciplineStudent(widget.studentId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: CupertinoColors.white),
          onPressed: () {
            Navigator.pop(context);
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
        child: Obx(() => controller.isLoading.isTrue
            ? Center(
                child: CircularProgressBar(
                  color: primarycolor,
                ),
              )
            : controller.dicipline.isNotEmpty
                ? ListView.builder(
                    itemCount: controller.dicipline.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Get.to(() =>
                                DiciplineDetail(controller.dicipline[index]));
                          },
                          child: DiciplineCard(
                              dicipline: controller.dicipline[index]));
                    },
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/imgs/notfound.png'),
                      Text('nosanction'.tr),
                    ],
                  )),
      ),
    );
  }
}
