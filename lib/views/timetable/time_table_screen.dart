import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Color(0xFFB97CFC),),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Time Line',style: TextStyle(color:Color(0xFF7590d6) ),),
      ),
      body: GetBuilder<ChildrenController>(
        builder: (timetableController) {
          if (timetableController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (timetableController.timetable.isEmpty) {
            return const Center(
              child: Text('No Time Table found.'),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
