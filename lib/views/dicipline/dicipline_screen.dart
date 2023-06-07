import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/mychildren_controller/mychildren_controller.dart';
import '../../routes/routes.dart';
import '../../theme/app_colors.dart';
import 'package:tsdoha/model/dicipline_model.dart';

import 'details_dicipline.dart';

class DiciplineScreen extends StatefulWidget {
  final int? studentId;
  DiciplineScreen({Key? key, this.studentId}) : super(key: key);

  @override
  State<DiciplineScreen> createState() => _DiciplineScreenState();
}

class _DiciplineScreenState extends State<DiciplineScreen> {
  final ChildrenController controller = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchdiciplineStudent(widget.studentId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: CupertinoColors.white),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: primarycolor,
        title: Text(
          'discipline'.tr,
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
        child: Obx(
          () {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: controller.dicipline.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                    Get.to(()=>DiciplineDetail(controller.dicipline[index]));
                    },
                      child: DiciplineCard(controller.dicipline[index]));
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DiciplineCard extends StatelessWidget {
  final Dicipline? dicipline;

  const DiciplineCard(
    this.dicipline, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Get.locale;
    final isArabic = locale?.languageCode == 'ar';
    bool isMessageRead = dicipline!.state! == 'read';
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  dicipline!.typeOfSanction!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: _buildCircleAvatar(dicipline!.teacherImage!.toString()),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        dicipline!.teacher!,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      dicipline!.date!,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          isArabic == true
              ? Positioned(
                  top: 8.0,
                  left: 8.0,
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isMessageRead ? Colors.green : Colors.red,
                    ),
                  ),
                )
              : Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isMessageRead ? Colors.green : Colors.red,
                    ),
                  ),
                ),
        ],
      ),
    );
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
        print('Invalid image data: $e');
      }
    }
    return const CircleAvatar(
      backgroundImage: AssetImage("assets/imgs/user-avatar.png"),
      radius: 30.0,
    );
  }
}
