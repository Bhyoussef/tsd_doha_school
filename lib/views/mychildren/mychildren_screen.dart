import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/theme/app_colors.dart';
import '../../constant/constant.dart';
import '../../controller/mychildren_controller/mychildren_controller.dart';
import 'children_details_screen.dart';
import 'widget/child_card_widget.dart';

class MyChildrenScreen extends StatelessWidget {
  final controller = Get.put(ChildrenController());

  MyChildrenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(
            () {
              if (controller.isLoading.value) {
                return  Center(
                  child: CircularProgressBar(

                    color: primarycolor,

                  )
                  ,
                );
              } else {
                return ListView.builder(
                  itemCount: controller.children.length,
                  itemBuilder: (context, index) {
                    final student = controller.children[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => DetailScreen(student: student),
                            transition: Transition.downToUp);
                      },
                      child: Padding(
                        padding: const  EdgeInsets.only(bottom: 10),
                        child: ChildCardWidget(student: student),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
