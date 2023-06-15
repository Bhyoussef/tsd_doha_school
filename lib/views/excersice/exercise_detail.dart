import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../controller/exercise/exercise_controller.dart';
import '../../model/exersice_model.dart';
import '../../routes/routes.dart';
import '../../theme/app_colors.dart';
import '../../utils/shared_preferences.dart';
import '../mymessages/message_received_details.dart';
import 'exercise_add_comment.dart';
import 'widget/exercise_detail_widget.dart';
import 'widget/teacher_cart.dart';

class ExerciseDetail extends StatefulWidget {
  final Exersice? exercise;
  ExerciseDetail(this.exercise, {Key? key}) : super(key: key);

  @override
  State<ExerciseDetail> createState() => _ExerciseDetailState();
}

class _ExerciseDetailState extends State<ExerciseDetail> {
  final ExerciseController controller = Get.find<ExerciseController>();

  @override
  void initState() {
    super.initState();
    final ExerciseController controller = Get.find<ExerciseController>();
    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
      controller.getComments(uid, widget.exercise!.iD!);
    });
  }

  @override
  void dispose() {
    controller.isloading.value = false;
    controller.comments.clear();
    controller.attachments.clear();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: CupertinoColors.white),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: primarycolor,
        title: Text(
          'exercisedetail'.tr,
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            TeacherCardPayment(exercise: widget.exercise),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () {}, child: DetailExersiceCard(widget.exercise)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'comments'.tr,
                    style: TextStyle(
                      color: primarycolor,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
            comments()
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Get.to(() => AddCommentExercise(exercise: widget!.exercise!));
        },
        style: ElevatedButton.styleFrom(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          primary: primarycolor,
        ),
        child: Text(
          'addcomment'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget comments() {
    return Obx(() {
      if (controller.isloading.isTrue) {
        return Center(
          child: CircularProgressBar(
            color: primarycolor,
          ),
        );
      } else if (controller.comments.isNotEmpty) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.comments.length,
          itemBuilder: (context, index) {
            final comment = controller.comments[index];
            return CommentCard(comment: comment);
          },
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/imgs/notfound.png'),
            Text('noexercise'.tr),
          ],
        );
      }
    });
  }

}
