import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../controller/mychildren_controller/mychildren_controller.dart';
import '../../theme/app_colors.dart';

class ExerciseScreen extends StatefulWidget {
  final int studentId;

  const ExerciseScreen({Key? key, required this.studentId}) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final ChildrenController controller = Get.find<ChildrenController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchExerciseStudent(widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color:CupertinoColors.white),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: primarycolor,
        title:  Text('exercises'.tr,style: const  TextStyle(
            color: CupertinoColors.white,fontWeight: FontWeight.bold),),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/imgs/tsdIcon.png',
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
              () {
            final exerciseController = Get.find<ChildrenController>();

            if (exerciseController.isLoading.value) {
              return Center(
                child: CircularProgressBar(color: primarycolor),
              );
            } else if (exerciseController.exersice.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/imgs/notfound.png'),
                   Text('noexercise'.tr),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),

    );
  }
}
