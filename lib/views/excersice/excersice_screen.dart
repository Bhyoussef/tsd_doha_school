import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/constant/constant.dart';
import 'package:tsdoha/controller/mychildren_controller/mychildren_controller.dart';
import 'package:tsdoha/routes/routes.dart';
import 'package:tsdoha/theme/app_colors.dart';
import 'package:tsdoha/utils/shared_preferences.dart';
import 'exercise_detail.dart';
import 'widget/exersice_cart.dart';

class ExerciseScreen extends StatefulWidget {
  final int? studentId;

  const ExerciseScreen({Key? key, this.studentId}) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final controller = Get.find<ChildrenController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final uid = await SharedData.getFromStorage('parent', 'object', 'uid');
      controller.fetchExerciseStudent(widget.studentId!, uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final exerciseController = Get.find<ChildrenController>();
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
          'exercises'.tr,
          style: const TextStyle(
              color: CupertinoColors.white, fontWeight: FontWeight.bold),
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
        child: Obx(() => exerciseController.isLoading.isTrue
            ? Center(
                child: CircularProgressBar(color: primarycolor),
              )
            : exerciseController.exersice.isNotEmpty
                ? ListView.builder(
                    itemCount: exerciseController.exersice.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Get.to(() => ExerciseDetail(
                                exerciseController.exersice[index]));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ExerciseCard(
                                exerciseController.exersice[index]),
                          )
                      );
                    },
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/imgs/notfound.png'),
                      Text('noexercise'.tr),
                    ],
                  )),
      ),
    );
  }
}
