import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tunisian_school_doha/theme/app_colors.dart';
import '../../constant/constant.dart';
import '../../controller/mychildren_controller/dowload_file_controller.dart';
import '../../controller/mychildren_controller/mychildren_controller.dart';

class TimeTableScreen extends StatefulWidget {
  final int studentId;

  TimeTableScreen({Key? key, required this.studentId}) : super(key: key);

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  final ChildrenController controller = Get.find<ChildrenController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      controller.fetchTiemTableStudent(widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primarycolor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color:CupertinoColors.white,),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Time Line',style: TextStyle(
            color:CupertinoColors.white,fontWeight: FontWeight.bold ),),
      ),
      body: GetBuilder<ChildrenController>(
        builder: (timetableController) {
          if (timetableController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (timetableController.timetable.isEmpty) {
            return  Center(
              child: Image.asset('assets/imgs/notfound.png'),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
