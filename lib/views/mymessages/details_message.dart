import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../controller/message_controller/message_received_controller.dart';
import '../../controller/mychildren_controller/dowload_file_controller.dart';
import '../../model/attachement_model.dart';
import '../../model/child_model.dart';
import '../../model/comments_model.dart';
import '../../model/message_model.dart';
import '../../theme/app_colors.dart';
import '../../utils/shared_preferences.dart';
import 'add_comment.dart';


class DetailsMessageReceived extends StatefulWidget {
  final Message message;
  final FileDownloadController downloadController;
  const DetailsMessageReceived({Key? key, required this.message, required this.downloadController}) : super(key: key);

  @override
  State<DetailsMessageReceived> createState() => _DetailsMessageReceivedState();
}

class _DetailsMessageReceivedState extends State<DetailsMessageReceived> {
  final MessageReceivedController controller = Get.find<MessageReceivedController>();
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
      controller.getChildDetail(uid, widget.message.studentId!);
      controller.getComments(uid, widget.message.iD!);
      if (kDebugMode) {
        print(uid.toString());
      }
      if (kDebugMode) {
        print(widget.message.studentId.toString());
      }
      if (kDebugMode) {
        print(widget.message.iD.toString());
      }
    });
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
            Get.back();
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
            child: Image.asset(
              'assets/imgs/tsdIcon.png',
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
      body: Obx(
            () {
          if (controller.isLoading.value) {
            return  Center(
              child: CircularProgressIndicator(color: primarycolor,),
            );
          } else if (controller.comments.isEmpty) {
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/imgs/notfound.png'),
                    const Text('No Messages Found')
                  ],
                )
            );
          } else {
            return ListView(
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
            );
          }
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) =>  AddCommentPage(message:widget.message),
          );
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
    if (controller.isLoading.value) {
      return Center(
        child: CircularProgressIndicator(color: primarycolor,),
      );
    } else if (controller.comments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/imgs/notfound.png'),
            const Text('No Comments Found')
          ],
        ),
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
  }


  void sendComment() {
    final comment = commentController.text;
    // send the comment
    commentController.clear();
  }
}

class CommentCard extends StatelessWidget {
  final MessageReceivedController controller = Get.find<MessageReceivedController>();
  final Comment comment;

   CommentCard({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  comment.recordName!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                buildVoteButton()
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: _buildCircleAvatar(comment.authorId!.image!),
                  radius: 40.0,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    comment.authorId!.name!,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text( _removeAllHtmlTags(comment.body!),
           maxLines: 5, ),
          ),
          if (comment.attachments != null && comment.attachments!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'attachemnts'.tr,
                    style:const  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return CircularProgressBar(color: primarycolor);
                    } else {
                      return Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: comment.attachments!
                            .map((attachment) => AttachmentWidget(attachment: attachment, comment: comment,))
                            .toList(),
                      );
                    }
                  }),
                ],
              ),
            ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  '',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );


  }
  Widget buildVoteButton() {
    final bool isVoted = comment.voteUserIds!.isNotEmpty;
    return IconButton(
      onPressed: () {
        controller.voteComment(comment.id!);
      },
      icon: Icon(
        isVoted ? Icons.favorite : Icons.favorite_border,
        color: isVoted ? Colors.red : Colors.red,
      ),
    );
  }

  String _removeAllHtmlTags(String htmlText) {
    if (htmlText == null) return 'N/A';
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
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
    return AssetImage('assets/imgs/user-avatar.png');
  }

}

class AttachmentWidget extends StatelessWidget {
  final FileDownloadController downloadcontroller =
  Get.find<FileDownloadController>();
  final Attachment attachment;
  final Comment comment;

   AttachmentWidget({
    Key? key,
    required this.attachment, required this.comment,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            attachment.fileName!,
            maxLines: 5,
            overflow: TextOverflow.clip,
            style: const TextStyle(fontSize: 14.0),
          ),
        ),
        IconButton(
          icon:  Icon(Icons.download,
            color: primarycolor ,),
          onPressed: () {
            String attachementid =  comment.attachmentIds!.toString().substring(1, comment.attachmentIds!.toString().length - 1);
            SharedData.getFromStorage('parent', 'object', 'uid').then((uid) {
              downloadcontroller.downloadFile(
                uid,
                attachementid!,
                attachment.fileName ?? '',
              );
            });
            print('here${attachementid}');
          },
        )
      ],
    );
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
                        radius: 40.0,
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
                                )
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
