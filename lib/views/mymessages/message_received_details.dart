import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/controller/home_controller.dart';
import 'package:tsdoha/views/home/home_screen.dart';
import '../../constant/constant.dart';
import '../../controller/message_controller/message_received_controller.dart';
import '../../controller/dowload_file_controller.dart';
import '../../model/child_model.dart';
import '../../model/message_model.dart';
import '../../theme/app_colors.dart';
import '../../utils/shared_preferences.dart';
import 'add_comment.dart';
import 'widget/comment_card.dart';


class DetailsMessageReceived extends StatefulWidget {
  final Message message;
  final FileDownloadController downloadController;
  const DetailsMessageReceived({Key? key, required this.message, required this.downloadController}) : super(key: key);

  @override
  State<DetailsMessageReceived> createState() => _DetailsMessageReceivedState();
}

class _DetailsMessageReceivedState extends State<DetailsMessageReceived> {
  final MessageReceivedController controller = Get.find<MessageReceivedController>();
  final HomeController controllerhome = Get.find<HomeController>();
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final MessageReceivedController controller = Get.find<MessageReceivedController>();
    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
      controller.getChildDetail(uid, widget.message.studentId!);
      controller.getComments(uid, widget.message.iD!);

    });
  }

  @override
  void dispose() {
    controller.comments.clear();
    controller.childDetail.clear();
    controller.isLoading.value = false;
    controller.isLoadingAttachments.value = false;
    controller.dispose();
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
        title:  Text(
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
              onTap: (){
                Get.to(()=>HomeScreen());
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
      body:  ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                messageContent(),
          Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
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

      comments(),
              ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Get.to(()=> AddCommentPage(message:widget.message));

        },
        style: ElevatedButton.styleFrom(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          primary: primarycolor,
        ),
        child:  Text(
          'addcomment'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget messageContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MessageCardReceived(
          title: widget.message.titleOfMessage ?? '',
          image: widget.message.teacherImage ?? '',
          sender: widget.message.teacher ?? '',
          message: widget.message.message ?? '',
          details: '${widget.message.student ?? ''} • ${widget.message.date ?? ''}',
          isRead: widget.message.state!,
          isAttached: widget.message.attachments!.isEmpty,
          attachments: widget.message.attachments!,
          downloadController:widget.downloadController

      ),
    );
  }

  Widget childContent() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        itemCount: controller.childDetail.length,
        itemBuilder: (context, index) {
          final child = controller.childDetail[index];
          return ChildCard(child: child);
        },
      ),
    );
  }

  Widget comments() {
    return Obx(() {
      if (controller.isLoadingAttachments.value) {
        return Center(
          child: CircularProgressBar(color: primarycolor,),
        );
      } else {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.comments.length,
          itemBuilder: (context, index) {
            final comment = controller.comments[index];
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: CommentCard(comment: comment),
            );
          },
        );
      }
    });
  }
}
class ChildCard extends StatelessWidget {
  final Mychildreen child;

  const ChildCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: MemoryImage(base64Decode(child.image!)),
                      radius: 20.0,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        child.name!,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

class MessageCardReceived extends StatelessWidget {
  final String title;
  final String image;
  final String sender;
  final String message;
  final String details;
  final String isRead;
  final bool isAttached;
  final List<Attachments> attachments;
  final FileDownloadController downloadController;


  const MessageCardReceived({super.key,
    required this.title,
    required this.image,
    required this.sender,
    required this.message,
    required this.details,
    required this.isRead,
    required this.isAttached,
    required this.attachments, required this.downloadController,

  });

  @override
  Widget build(BuildContext context) {
    final locale = Get.locale;
    final isArabic = locale?.languageCode == 'ar';
    return Padding(
      padding: const EdgeInsets.all(4.0),
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
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
                      CircleAvatar(
                        backgroundImage: MemoryImage(base64Decode(image)),
                        radius: 30.0,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          sender,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 16.0, color: Colors.black),
                      children: [
                        TextSpan(
                          text: message,
                        ),
                      ],
                    ),
                  ),
                ),
                if (attachments.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'attachemnts'.tr,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: attachments.length,
                          itemBuilder: (context, index) {
                            final attachment = attachments[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  attachment.fileName ?? '',
                                  style: const TextStyle(fontSize: 14.0),
                                ),
                                IconButton(
                                  icon:  Icon(Icons.download,
                                    color: primarycolor ,),
                                  onPressed: () {

                                    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) {
                                      downloadController.downloadFile(
                                        uid,
                                        attachment.id.toString(),
                                        attachment.fileName ?? '',
                                      );
                                    });
                                    if (kDebugMode) {
                                      print('here${attachment.id}');
                                    }
                                  },
                                ),

                              ],
                            );
                          },
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
                        details,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            isArabic==true?Positioned(
              top: 8.0,
              left: 8.0,
              child: Container(
                width: 12.0,
                height: 12.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isRead =='read'  ? Colors.green : Colors.red,
                ),
              ),
            ): Positioned(
              top: 8.0,
              right: 8.0,
              child: Container(
                width: 12.0,
                height: 12.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isRead =='read'  ? Colors.green : Colors.red,
                ),
              ),
            ),
            isAttached ? Container() : isArabic==true?const Positioned(
              top: 8.0,
              left: 25.0,
              child: Icon(Icons.attach_file,),
            ): const Positioned(
              top: 8.0,
              right: 25.0,
              child: Icon(Icons.attach_file,),
            ),
          ],
        ),
      ),
    );
  }
}