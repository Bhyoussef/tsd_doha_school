import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tunisian_school_doha/theme/app_colors.dart';
import '../../model/child_model.dart';
import '../dicipline/dicipline_screen.dart';
import '../excersice/excersice_screen.dart';
import '../gradebook/books_screen.dart';
import '../recording/recordingScreen.dart';
import '../timetable/time_table_screen.dart';
import 'payments/details_payment_child.dart';

class DetailScreen extends StatelessWidget {
  final Mychildreen student;
  const DetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primarycolor, primarycolor],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            height: 500,
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: CupertinoColors.white,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  _buildCircleAvatar(student.image),
                  const SizedBox(height: 8.0),
                  Text(
                    '${student.name ?? ''} ${student.lastName ?? ''}',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${student.nameAr ?? ''} ${student.lastNameAr ?? ''}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    student.academicYear.toString(),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () => _showQrImageDialog(context, student.ref!),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: QrImageView(
                        data: student.ref!,
                        version: QrVersions.auto,
                        backgroundColor: Colors.white,
                        size: 100.0,
                      ),
                    ),
                  ),
                  Text(
                    student.ref.toString(),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 500,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    _buildGridItem(
                        context, 'Exercices', navigateToExercisePage),
                    _buildGridItem(context, 'Payments', navigateToPaymentPage),
                    _buildGridItem(
                        context, 'Dicipline', navigateToDiciplinePage),
                    _buildGridItem(
                        context, 'Time Tables', navigateToTimeTablePage),
                    _buildGridItem(context, 'GradeBook', navigateToBookPage),
                    _buildGridItem(
                        context, 'Recording', navigateToRecordingPage),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(
    BuildContext context,
    String title,
    VoidCallback navigateCallback,
  ) {
    return GestureDetector(
      onTap: navigateCallback,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconForTitle(title),
              size: 36.0,
              color: Colors.black,
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title.toLowerCase()) {
      case 'exercices':
        return Icons.fitness_center;
      case 'payments':
        return Icons.payment;
      case 'dicipline':
        return Icons.school;
      case 'time tables':
        return Icons.schedule;
      case 'gradebook':
        return Icons.menu_book;
      case 'recording':
        return Icons.mic;
      default:
        return Icons.error_outline;
    }
  }

  void navigateToRecordingPage() {
    Get.to(() => const RecordingScreen());
  }

  void navigateToExercisePage() {
    Get.to(() => ExerciseScreen(studentId: student.studentId!));
  }

  void navigateToBookPage() {
    Get.to(() => BookListScreen(studentId: student.studentId!));
  }

  void navigateToDiciplinePage() {
    Get.to(() => const DiciplineScreen());
  }

  void navigateToPaymentPage() {
    Get.to(() => DetailsPaymentChild(
          studentId: student.studentId!,
          student: student,
        ));
  }

  void navigateToTimeTablePage() {
    Get.to(() => TimeTableScreen(studentId: student.studentId!));
  }
}

Widget _buildCircleAvatar(dynamic image) {
  if (image != null) {
    try {
      final decodedImage = base64Decode(image.toString());
      final imageBytes = Uint8List.fromList(decodedImage);
      return CircleAvatar(
        backgroundImage: MemoryImage(imageBytes),
        radius: 30.0,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Invalid image data: $e');
      }
    }
  }
  return const CircleAvatar(
    backgroundImage: AssetImage("assets/imgs/user-avatar.png"),
    radius: 30.0,
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
