import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tunisian_school_doha/model/exersice_model.dart';
import 'package:tunisian_school_doha/model/time_table_model.dart';
import 'package:tunisian_school_doha/utils/shared_preferences.dart';
import 'package:tunisian_school_doha/model/book_model.dart';
import 'package:tunisian_school_doha/model/child_model.dart';
import 'package:tunisian_school_doha/services/mychildren.dart';

class ChildrenController extends GetxController {
  final children = <Mychildreen>[].obs;
  final books = <Book>[].obs;
  final exersice = <Exersice>[].obs;
  final timetable = <TimeTable>[].obs;
  RxBool isLoading = false.obs;
  ChildrenController get timetableController => this;

  @override
  void onInit() {
    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
      fetchChildren(uid);
    });
    super.onInit();
  }

  Future<void> fetchChildren(uid) async {
    try {
      isLoading(true);
      final childrenList = await ApiServiceMyChildren.getChildren(uid);
      children.assignAll(childrenList);
      update();
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchBooksStudents(int studentId) async {
    try {
      isLoading(true);
      final fetchedBooks = await ApiServiceMyChildren.fetchBooks(studentId);
      books.assignAll(fetchedBooks);
      update();
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchExerciseStudent(int studentId) async {
    try {
      isLoading(true);
      final fetchedExercise = await ApiServiceMyChildren.fetchExercise(
        studentId);
      exersice.assignAll(fetchedExercise);
      update();
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchTiemTableStudent(int studentId,String ClassId) async {
    try {
      isLoading(true);
      final fetchedtimetable = await ApiServiceMyChildren.fetchTimeTable(studentId,ClassId);
      timetable.assignAll(fetchedtimetable);
      if (kDebugMode) {
        print('here$fetchedtimetable');
      }
      update();
    } finally {
      isLoading(false);
    }
  }
}
