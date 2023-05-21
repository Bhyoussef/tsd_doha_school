import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/mychildren_controller/mychildren_controller.dart';
import '../../model/child_model.dart';
import 'children_details_screen.dart';
import 'widget/child_card_widget.dart';

class MyChildrenScreen extends StatelessWidget {
  final controller = Get.put(ChildrenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: controller.children.length,
            itemBuilder: (context, index) {
              final student = controller.children[index];
              return GestureDetector(
                onTap: () {
                  navigateToDetailScreen(student);
                },
                child: ChildCardWidget(student: student),
              );
            },
          );
        }
      }),
    );
  }

  void navigateToDetailScreen(Mychildreen student) {
    Get.to(() => DetailScreen(student: student));
  }
}
