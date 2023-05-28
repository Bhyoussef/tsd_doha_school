import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/message_controller/message_received_controller.dart';
import '../../model/attachement_model.dart';
import '../../model/child_model.dart';
import '../../model/comments_model.dart';
import '../../model/message_model.dart';
import '../../theme/app_colors.dart';
import '../../utils/shared_preferences.dart';
import 'add_comment.dart';
import 'widget/message_card.dart';

class DetailsMessageReceived extends StatefulWidget {
  final Message message;
  const DetailsMessageReceived({Key? key, required this.message}) : super(key: key);

  @override
  State<DetailsMessageReceived> createState() => _DetailsMessageReceivedState();
}

class _DetailsMessageReceivedState extends State<DetailsMessageReceived> {
  final MesaageReceivedController controller = Get.find<MesaageReceivedController>();
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
        title: const Text(
          'Message Details',
          style: TextStyle(
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
                        'Comments',
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
            builder: (context) => const AddCommentPage(),
          );
        },
        style: ElevatedButton.styleFrom(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          primary: primarycolor,
        ),
        child: const Text(
          'Add Comment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget messageContent() {
    return MessageCardReceived(
      title: widget.message.titleOfMessage ?? '',
      image: widget.message.teacherImage ?? '',
      sender: widget.message.teacher ?? '',
      message: widget.message.message ?? '',
      details: '${widget.message.student ?? ''} • ${widget.message.date ?? ''}',
      isRead: widget.message.state!,
      isAttached: widget.message.attachments!.isEmpty,
      attachments: widget.message.attachments!,
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
          return CommentCard(comment: comment);
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
  final MesaageReceivedController controller = Get.find<MesaageReceivedController>();
  final Comment comment;

   CommentCard({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.grey.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              comment.recordName!,
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
                  backgroundImage: MemoryImage(base64Decode(comment.authorId!.image!)),
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
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16.0, color: Colors.black),
                children: [
                  TextSpan(
                    text: _removeAllHtmlTags(comment.body!),
                  ),
                ],
              ),
            ),
          ),
          if (comment.attachments != null && comment.attachments!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Attachments:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return CircularProgressIndicator(color: primarycolor);
                    } else {
                      return Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: comment.attachments!
                            .map((attachment) => AttachmentWidget(attachment: attachment))
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

  String _removeAllHtmlTags(String htmlText) {
    if (htmlText == null) return 'N/A';
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }
}

class AttachmentWidget extends StatelessWidget {
  final Attachment attachment;

  const AttachmentWidget({
    Key? key,
    required this.attachment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.attachment),
          const SizedBox(width: 4.0),
          Flexible(
            child: Text(
              attachment.fileName!,
              maxLines: 5,
              overflow: TextOverflow.clip,
              style: const TextStyle(fontSize: 14.0),
            ),
          ),
        ],
      ),
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
