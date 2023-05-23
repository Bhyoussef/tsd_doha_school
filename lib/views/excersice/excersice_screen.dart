import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tunisian_school_doha/theme/app_colors.dart';
import '../../constant/constant.dart';
import '../../controller/mychildren_controller/dowload_file_controller.dart';
import '../../controller/mychildren_controller/mychildren_controller.dart';

class ExerciseScreen extends StatefulWidget {
  final int studentId;

  ExerciseScreen({Key? key, required this.studentId}) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final ChildrenController controller = Get.find<ChildrenController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
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
        title: const Text('Exercise ',style: TextStyle(
            color: CupertinoColors.white,fontWeight: FontWeight.bold),),
      ),
      body: GetBuilder<ChildrenController>(
        builder: (exerciseController) {
          if (exerciseController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (exerciseController.exersice.isEmpty) {
            return const Center(
              child: Text('No Exercise found.'),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
