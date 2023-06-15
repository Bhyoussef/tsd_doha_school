import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controller/dowload_file_controller.dart';
import '../../../model/exersice_model.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/shared_preferences.dart';

class DetailExersiceCard extends StatelessWidget {
  final Exersice? exercise;

  DetailExersiceCard(
      this.exercise, {
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FileDownloadController controller =
    Get.find<FileDownloadController>();
    final locale = Get.locale;
    final isArabic = locale?.languageCode == 'ar';
    bool isMessageRead = exercise!.state! == 'read';
    bool isAttached=exercise!.attachmentId!.isEmpty;
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
                  exercise!.titleOfHomework!,
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

                    Expanded(
                      child: Text(
                        exercise!.messageOfHomework!,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: exercise!.attachmentId!.length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(exercise!.attachmentId![index].fileName!),
                              IconButton(
                                icon: Icon(
                                  Icons.download,
                                  color: primarycolor,
                                ),
                                onPressed: () async {
                                  final uid = await SharedData.getFromStorage(
                                      'parent', 'object', 'uid');
                                  controller.downloadFile(
                                      uid,
                                      exercise!.attachmentId![index].id!
                                          .toString(),
                                      exercise!.attachmentId![index].fileName!);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              exercise!.video != 'false'
                  ? Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    MaterialButton(
                      minWidth:
                      MediaQuery.of(context).size.width,
                      height: 50,
                      color: primarycolor,
                      textColor: Colors.white,
                      onPressed: () {
                        _launchURL(exercise!.video!);
                      },
                      child: Text('watchvideo'.tr),
                    ),
                  ],
                ),
              )
                  : Container(),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      exercise!.date!,
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

          isAttached
              ? Container()
              : isArabic == true
              ? const Positioned(
            top: 8.0,
            left: 25.0,
            child: Icon(
              Icons.attach_file,
            ),
          )
              : const Positioned(
            top: 8.0,
            right: 25.0,
            child: Icon(
              Icons.attach_file,
            ),
          ),

        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  
}