import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tunisian_school_doha/theme/app_colors.dart';
import '../../controller/message_controller/message_received_controller.dart';
import '../../model/attachement_model.dart';
import '../../model/child_model.dart';
import '../../model/message_detail.dart';
import '../../model/message_model.dart';
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
  final MesaageReceivedController controller =
  Get.find<MesaageReceivedController>();
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
      controller.getChildDetail(uid, widget.message.studentId!);
      controller.getComments(uid, widget.message.iD!);
      print(uid.toString());
      print(widget.message.studentId.toString());
      print(widget.message.iD.toString());
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
                      padding:const  EdgeInsets.all(8.0),
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
        itemCount: controller.childdetail.length,
        itemBuilder: (context, index) {
          final child = controller.childdetail[index];
          return ChildCard(child: child);
        },
      ),
    );
  }

  Widget comments() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.comments.length,
          itemBuilder: (context, index) {
            final comment = controller.comments[index];
            final attachments = controller.allattachements[index];

            return CommentCard(
              comments: comment,
              attachments: attachments as List<Attachment>,
            );
          },
        ),
      ),
    );
  }


  void sendComment() {
    final comment = commentController.text;
    // send the comment
    commentController.clear();
  }
}

class CommentCard extends StatelessWidget {
  final MessageDetail comments;
  final List<Attachment> attachments;

  const CommentCard({
    Key? key,
    required this.comments,
    required this.attachments,
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
              comments.recordName!,
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
                  backgroundImage:
                  MemoryImage(base64Decode(comments.authorId!.image!)),
                  radius: 20.0,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    comments.authorId!.name!,
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
                    text: _removeAllHtmlTags(comments.body!),
                  ),
                ],
              ),
            ),
          ),
          if (attachments.isNotEmpty) ...attachments.map((attachment) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.attach_file),
                const SizedBox(width: 4.0),
                Expanded(
                  child: Text(attachment.fileName!),
                ),
              ],
            ),
          )),
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


