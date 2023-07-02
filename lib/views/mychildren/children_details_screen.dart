import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tsdoha/constant/constant.dart';
import 'package:tsdoha/controller/mychildren_controller/mychildren_controller.dart';
import 'package:tsdoha/utils/shared_preferences.dart';
import 'package:tsdoha/views/home/home_screen.dart';
import '../../model/child_model.dart';
import '../../theme/app_colors.dart';
import '../dicipline/dicipline_screen.dart';
import '../excersice/excersice_screen.dart';
import '../gradebook/books_screen.dart';
import '../recording/recordingScreen.dart';
import '../timetable/time_table_screen.dart';
import 'payments/details_payment_child.dart';

class DetailScreen extends StatefulWidget {
  final Mychildreen? student;
  final int? studentId;
  const DetailScreen({Key? key, this.student, this.studentId}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ChildrenController controller = Get.find<ChildrenController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
        controller.fetchSinglechild(uid, widget.studentId!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarycolor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: CupertinoColors.white),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Get.to(() => HomeScreen());
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
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Stack(
            children: [
              SingleChildScrollView(child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressBar(
                      color: CupertinoColors.white,
                    ),
                  );
                } else if (controller.child.isNotEmpty) {
                  return Column(
                    children: [
                      Container(
                        color: primarycolor,
                        width: double.infinity,
                        child: Column(
                          children: [
                            _buildCircleAvatar(controller.child[0].image),
                            const SizedBox(height: 8.0),
                            Text(
                              '${controller.child[0].name ?? ''} ${controller.child[0].lastName ?? ''}',
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '${controller.child[0].nameAr ?? ''} ${controller.child[0].lastNameAr ?? ''}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              controller.child[0].academicYear.toString(),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () => _showQrImageDialog(
                                  context, controller.child[0].ref!),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: QrImageView(
                                  data: controller.child[0].ref!,
                                  version: QrVersions.auto,
                                  backgroundColor: Colors.white,
                                  size: 100.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                controller.child[0].ref.toString(),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: GridView.count(
                            primary: false,
                            shrinkWrap: true,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            crossAxisCount: 2,
                            children: [
                              _buildGridItem(
                                  context, 'exercises', navigateToExercisePage),
                              _buildGridItem(
                                  context, 'payments', navigateToPaymentPage),
                              _buildGridItem(context, 'discipline',
                                  navigateToDisciplinePage),
                              _buildGridItem(
                                  context, 'timetable', navigateToTimeTablePage),
                              _buildGridItem(
                                  context, 'gradebook', navigateToBookPage),
                              _buildGridItem(
                                  context, 'recording', navigateToRecordingPage),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Column(
                      children: [
                        Image.asset('assets/imgs/notfound.png'),
                        Text('nogradebooks'.tr),
                      ],
                    ),
                  );
                }
              }))
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider<Object> _getImageForTitle(String title) {
    switch (title.toLowerCase()) {
      case 'exercises':
        return const AssetImage('assets/imgs/bulletin.jpg');
      case 'payments':
        return const AssetImage('assets/imgs/paymen.png');
      case 'discipline':
        return const AssetImage('assets/imgs/discipline.png');
      case 'timetable':
        return const AssetImage('assets/imgs/elearn.png');
      case 'gradebook':
        return const AssetImage('assets/imgs/course-icon.jpg');
      case 'recording':
        return const AssetImage('assets/imgs/course-icon.jpg');
      default:
        return const AssetImage('assets/imgs/error.png');
    }
  }

  Widget _buildGridItem(
    BuildContext context,
    String title,
    VoidCallback navigateCallback,
  ) {
    final translatedTitle = title.tr;

    return GestureDetector(
      onTap: navigateCallback,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: _getImageForTitle(title),
              width: 36.0,
              height: 36.0,
              color: Colors.black,
            ),
            const SizedBox(height: 8.0),
            Text(
              translatedTitle,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToRecordingPage() {
    Get.to(() => RecordingScreen(), transition: Transition.circularReveal);
  }

  void navigateToExercisePage() {
    Get.to(() => ExerciseScreen(studentId: widget.student!.studentId!),
        transition: Transition.circularReveal, duration: Duration(seconds: 1));
  }

  void navigateToBookPage() {
    Get.to(() => BookListScreen(studentId: controller.child[0].studentId),
        transition: Transition.circularReveal, duration: Duration(seconds: 1));
  }

  void navigateToDisciplinePage() {
    Get.to(() => DiciplineScreen(studentId: widget.student!.studentId!),
        transition: Transition.circularReveal, duration: Duration(seconds: 1));
  }

  void navigateToPaymentPage() {
    Get.to(
        () => DetailsPaymentChild(
              studentId: widget.student!.studentId!,
              student: widget.student!,
            ),
        transition: Transition.circularReveal,
        duration: Duration(seconds: 1));
  }

  void navigateToTimeTablePage() {
    Get.to(
        () => TimeTableScreen(
            studentId: widget.student!.studentId!, student: widget.student!),
        transition: Transition.circularReveal,
        duration: Duration(seconds: 1));
  }
}

Widget _buildCircleAvatar(dynamic image) {
  if (image != null) {
    try {
      final decodedImage = base64Decode(image.toString());
      final imageBytes = Uint8List.fromList(decodedImage);
      return CircleAvatar(
        backgroundImage: MemoryImage(imageBytes),
        radius: 40.0,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Invalid image data: $e');
      }
    }
  }
  return const CircleAvatar(
    backgroundImage: AssetImage("assets/imgs/user.png"),
    radius: 40.0,
  );
}

void _showQrImageDialog(BuildContext context, String qrData) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: qrData,
                version: QrVersions.auto,
                foregroundColor: Colors.black,
                size: 200.0,
              ),
              const SizedBox(height: 16.0),
              Text(
                qrData,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      );
    },
  );
}
