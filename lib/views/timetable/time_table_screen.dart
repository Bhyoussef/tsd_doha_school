import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../controller/mychildren_controller/mychildren_controller.dart';
import '../../model/child_model.dart';
import '../../routes/routes.dart';
import '../../theme/app_colors.dart';
import 'widget/date_range_widget.dart';
import 'widget/timetable_entry_widget.dart';

class TimeTableScreen extends StatefulWidget {
  final int studentId;
  final Mychildreen student;

  const TimeTableScreen({
    Key? key,
    required this.studentId,
    required this.student,
  }) : super(key: key);

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  final ChildrenController controller = Get.find<ChildrenController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchTiemTableStudent(
        widget.studentId,
        widget.student.Class!,
      );
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
          icon: const Icon(Icons.arrow_back_ios, color: CupertinoColors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'timetable'.tr,
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
      body: Obx(() => controller.isLoading.isTrue
          ? Center(
              child: CircularProgressBar(
                color: primarycolor,
              ),
            )
          : controller.timetable.isNotEmpty
              ? Column(
                  children: [
                    DateRange(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.timetable.length,
                        itemBuilder: (context, index) {
                          final timetableEntry = controller.timetable[index];
                          return TimeTableEntry(timetableEntry);
                        },
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/imgs/notfound.png'),
                    Text('notimetablefound'.tr),
                  ],
                )),
    );
  }
}
