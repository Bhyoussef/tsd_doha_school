import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/mychildren_controller/mychildren_controller.dart';
import '../../model/child_model.dart';
import '../../model/time_table_model.dart';
import '../../theme/app_colors.dart';

class TimeTableScreen extends StatefulWidget {
  final int studentId;
  final Mychildreen student;

  const TimeTableScreen(
      {Key? key, required this.studentId, required this.student})
      : super(key: key);

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  final ChildrenController controller = Get.find<ChildrenController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      controller.fetchTiemTableStudent(widget.studentId, widget.student.Class!);
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
        title: const Text(
          'Time Table',
          style: TextStyle(
              color: CupertinoColors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: GetBuilder<ChildrenController>(
        builder: (timetableController) {
          if (timetableController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (timetableController.timetable.isEmpty) {
            return Center(
              child: Image.asset('assets/imgs/notfound.png'),
            );
          } else {
            return Column(
              children: [
                _buildDateRange(),
                Expanded(
                  child: ListView.builder(
                    itemCount: timetableController.timetable.length,
                    itemBuilder: (context, index) {
                      final timetableEntry =
                          timetableController.timetable[index];
                      return _buildTimetableEntry(timetableEntry);
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildDateRange() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final saturday = monday.add(Duration(days: 5));

    return Stack(
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://unsplash.it/1080/720?image=1044'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.purpleAccent.withOpacity(0.01),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('dd-MM-yyyy').format(monday),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'To',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('dd-MM-yyyy').format(saturday),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimetableEntry(TimeTable timetableEntry) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: primarycolor,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${timetableEntry.startTime ?? ''} - ${timetableEntry.endTime ?? ''}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    timetableEntry.day ?? '',
                    style:const  TextStyle(
                      fontSize: 20,fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    timetableEntry.teacher ?? '',
                    style:const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    timetableEntry.subject ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}
