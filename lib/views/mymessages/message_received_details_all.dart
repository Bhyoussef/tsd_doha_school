import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../controller/dowload_file_controller.dart';
import '../../controller/home_controller.dart';
import '../../controller/message_controller/message_received_controller.dart';
import '../../model/message_model.dart';
import '../../theme/app_colors.dart';
import '../../utils/shared_preferences.dart';
import '../home/home_screen.dart';
import 'add_comment.dart';

class DetailsMessageReceivedAll extends StatefulWidget {
  final Message message;
  final FileDownloadController downloadController;
  const DetailsMessageReceivedAll(
      {Key? key, required this.message, required this.downloadController})
      : super(key: key);

  @override
  State<DetailsMessageReceivedAll> createState() =>
      _DetailsMessageReceivedState();
}

class _DetailsMessageReceivedState extends State<DetailsMessageReceivedAll> {
  final MessageReceivedController controller =
  Get.find<MessageReceivedController>();
  final HomeController controllerhome = Get.find<HomeController>();
  final TextEditingController commentController = TextEditingController();
  final FileDownloadController downloadcontroller =
  Get.find<FileDownloadController>();

  @override
  void initState() {
    super.initState();
    final MessageReceivedController controller =
    Get.find<MessageReceivedController>();
    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
      controller.getComments(uid, widget.message.iD!);
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
        backgroundColor: primarycolor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: CupertinoColors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'messagedetails'.tr,
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
                Get.offAll(HomeScreen());
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
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
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
          GetX<MessageReceivedController>(
            builder: (controller) {
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
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    comment!.recordName!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: _buildCircleAvatar(
                                        comment!.authorId!.image!),
                                    radius: 30.0,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      comment!.authorId!.name!,
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _removeAllHtmlTags(comment!.body!),
                                maxLines: 5,
                              ),
                            ),
                            if (comment!.attachments != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'attachemnts'.tr,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Wrap(
                                      spacing: 8.0,
                                      runSpacing: 8.0,
                                      children: comment!.attachments!
                                          .map(
                                            (attachment) => Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                attachment.fileName ?? "",
                                                maxLines: 5,
                                                overflow:
                                                TextOverflow.clip,
                                                style: const TextStyle(
                                                    fontSize: 14.0),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.download,
                                                color: primarycolor,
                                              ),
                                              onPressed: () {
                                                String attachementid =
                                                comment.attachmentIds!
                                                    .toString()
                                                    .substring(
                                                    1,
                                                    comment.attachmentIds!
                                                        .toString()
                                                        .length -
                                                        1);
                                                SharedData.getFromStorage(
                                                    'parent',
                                                    'object',
                                                    'uid')
                                                    .then((uid) {
                                                  downloadcontroller
                                                      .downloadFile(
                                                    uid,
                                                    attachementid!,
                                                    attachment.fileName ??
                                                        '',
                                                  );
                                                });
                                                if (kDebugMode) {
                                                  print('here$attachementid');
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      )
                                          .toList(),
                                    )
                                  ],
                                ),
                              ),
                            const Divider(),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
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
            },
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Get.to(() => AddCommentPage(message: widget.message));
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

  ImageProvider _buildCircleAvatar(dynamic image) {
    if (image != null) {
      try {
        final decodedImage = base64Decode(image.toString());

        return MemoryImage(decodedImage);
      } catch (e) {
        if (kDebugMode) {
          print('Invalid image data: $e');
        }
      }
    }
    return const AssetImage('assets/imgs/user-avatar.png');
  }

  String _removeAllHtmlTags(String htmlText) {
    if (htmlText == null) return 'N/A';
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }
}
