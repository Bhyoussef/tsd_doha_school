import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tsdoha/model/exersice_model.dart';
import 'package:tsdoha/model/time_table_model.dart';
import 'package:tsdoha/utils/shared_preferences.dart';
import 'package:tsdoha/model/book_model.dart';
import 'package:tsdoha/model/child_model.dart';
import 'package:tsdoha/services/mychildren.dart';

class ChildrenController extends GetxController {
  final children = <Mychildreen>[].obs;
  final books = <Book>[].obs;
  final exersice = <Exersice>[].obs;
  final timetable = <TimeTable>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchChildren();
  }

  Future<void> _fetchChildren() async {
    final uid = await SharedData.getFromStorage('parent', 'object', 'uid');
    await fetchChildren(uid);
  }

  Future<void> fetchChildren(int uid) async {
    try {
      isLoading.value = true;
      final childrenList = await ApiServiceMyChildren.getChildren(uid);
      children.assignAll(childrenList);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBooksStudents(int studentId) async {
    try {
      isLoading.value = true;
      final fetchedBooks = await ApiServiceMyChildren.fetchBooks(studentId);
      books.assignAll(fetchedBooks);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchExerciseStudent(int studentId) async {
    try {
      isLoading.value = true;
      final fetchedExercise =
      await ApiServiceMyChildren.fetchExercise(studentId);
      exersice.assignAll(fetchedExercise);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTiemTableStudent(int studentId, String ClassId) async {
    try {
      isLoading.value = true;
      final fetchedtimetable =
      await ApiServiceMyChildren.fetchTimeTable(studentId, ClassId);
      timetable.assignAll(fetchedtimetable);
      if (kDebugMode) {
        print('here$fetchedtimetable');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
