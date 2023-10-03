import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../constant/constant.dart';
import '../../controller/home_controller.dart';
import '../../controller/message_controller/message_received_controller.dart';
import '../../controller/dowload_file_controller.dart';
import '../../model/attachement_model.dart';
import '../../model/comments_model.dart';
import '../../model/message_model.dart';
import '../../theme/app_colors.dart';
import '../../utils/shared_preferences.dart';
import '../home/home_screen.dart';
import 'add_comment.dart';

class DetailsMessageReceived extends StatefulWidget {
  final Message? message;
  final int? messageid;
  final FileDownloadController? downloadController;
  const DetailsMessageReceived(
      {Key? key, this.message,
       this.downloadController,
      this.messageid})
      : super(key: key);

  @override
  State<DetailsMessageReceived> createState() => _DetailsMessageReceivedState();
}

class _DetailsMessageReceivedState extends State<DetailsMessageReceived> {
  final MessageReceivedController controller =
      Get.find<MessageReceivedController>();
  final HomeController controllerhome = Get.find<HomeController>();
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
      controller.getComments(uid, widget.messageid!);
      controller.fetchSingleMessage(uid,widget.messageid);
      print(controller.receivedSingleMessage.toString());

      if (widget.message!.state! == 'sent') {
        controller.markAsRead(uid, widget.messageid!);
      } else {}
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          if (controller.isloading.isTrue) {
            return Center(
              child: CircularProgressBar(
                color: primarycolor,
              ),
            );
          } else {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                messageContent(),
                comments(),
              ],
            );
          }
        }),
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

  Widget messageContent() {

    return MessageCardReceived(
        title: widget.message!.titleOfMessage! ?? '',
        image: widget.message!.teacherImage! ?? '',
        sender: widget.message!.teacher! ?? '',
        message: widget.message!.message! ?? '',
        details:
            '${widget.message!.student! ?? ''} • ${widget.message!.date! ?? ''}',
        isRead: widget.message!.state!,
        isAttached: widget.message!.attachments!.isEmpty,
        attachments: widget.message!.attachments!,
        downloadController: widget!.downloadController!);
  }

  Widget comments() {
    return Obx(() {
      if (controller.isloading.isTrue) {
        return Column(
          children: [
            Center(
              child: Container(),
            ),
          ],
        );
      } else if (controller.comments.isNotEmpty) {
        return Column(
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.comments.length,
              itemBuilder: (context, index) {
                final comment = controller.comments[index];
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CommentCard(comment: comment),
                );
              },
            ),
          ],
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

  const MessageCardReceived({
    super.key,
    required this.title,
    required this.image,
    required this.sender,
    required this.message,
    required this.details,
    required this.isRead,
    required this.isAttached,
    required this.attachments,
    required this.downloadController,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Get.locale;
    final isArabic = locale?.languageCode == 'ar';
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
                      // Existing code...
                      Text(
                        'attachemnts'.tr,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListView.builder(
                        key: UniqueKey(),
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
                                icon: Icon(
                                  Icons.download,
                                  color: primarycolor,
                                ),
                                onPressed: () {
                                  SharedData.getFromStorage(
                                          'parent', 'object', 'uid')
                                      .then((uid) {
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
}



class MessageSingleReceived extends StatefulWidget {
 final MessageReceivedController? controller;


  const MessageSingleReceived({
    super.key,this.controller,
  });

  @override
  State<MessageSingleReceived> createState() => _MessageSingleReceivedState();
}

class _MessageSingleReceivedState extends State<MessageSingleReceived> {

  DateTime? _addHoursToDateTime(String? dateString) {
    if (dateString == null) return null;
    DateTime date = DateTime.parse(dateString);
    return date.add(Duration(hours: 3));
  }
  final FileDownloadController downloadController = Get.find<FileDownloadController>();

  final locale = Get.locale;


  bool isAttached = false;
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      if (widget.controller!.receivedSingleMessage != null &&
          widget.controller!.receivedSingleMessage!.isNotEmpty &&
          widget.controller!.receivedSingleMessage![0].attachments != null) {
        isAttached = widget.controller!.receivedSingleMessage![0].attachments!.isEmpty;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final isArabic = locale?.languageCode == 'ar';
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
                  widget.controller!.receivedSingleMessage[0].titleOfMessage!,
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
                      backgroundImage: MemoryImage(base64Decode(widget.controller!.receivedSingleMessage[0].teacherImage!)),
                      radius: 30.0,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        widget.controller!.receivedSingleMessage[0].teacher! ,
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
                        text: widget.controller!.receivedSingleMessage[0].message!,
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.controller!.receivedSingleMessage[0].attachments!.isNotEmpty)
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
                        physics: AlwaysScrollableScrollPhysics(),
                        key: UniqueKey(),
                        shrinkWrap: true,
                        itemCount: widget.controller!.receivedSingleMessage[0].attachments!.length,
                        itemBuilder: (context, index) {
                          final attachment = widget.controller!.receivedSingleMessage[0].attachments![index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                attachment.fileName ?? '',
                                style: const TextStyle(fontSize: 14.0),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.download,
                                  color: primarycolor,
                                ),
                                onPressed: () {
                                  SharedData.getFromStorage(
                                      'parent', 'object', 'uid')
                                      .then((uid) {
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
                      '${widget!.controller!.receivedSingleMessage[0]!.student ?? ""} • ${_addHoursToDateTime(widget!.controller!.receivedSingleMessage[0]!.date) ?? ""}'
                      ,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ],
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
}


class CommentCard extends StatefulWidget {
  final Comment? comment;

  const CommentCard({
    Key? key,
    this.comment,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final MessageReceivedController controller =
      Get.find<MessageReceivedController>();
  int uid = 0;
  bool isVoted = false;

  @override
  void initState() {
    super.initState();

    _fetchUid();
  }

  Future<void> _fetchUid() async {
    final fetchedUid =
        await SharedData.getFromStorage('parent', 'object', 'uid');
    setState(() {
      uid = fetchedUid;
      isVoted = widget.comment!.voteUserIds!.contains(uid);
    });
  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.comment!.recordName!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              buildVoteButton()
            ],
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      _buildCircleAvatar(widget.comment!.authorId!.image!),
                  radius: 30.0,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    widget.comment!.authorId!.name!,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _removeAllHtmlTags(widget.comment!.body!),
              maxLines: 5,
            ),
          ),
          if (widget.comment!.attachments != null &&
              widget.comment!.attachments!.isNotEmpty)
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.comment!.attachments!.length,
                    itemBuilder: (context, index) {
                      final attachment = widget.comment!.attachments![index];
                      return AttachmentWidget(
                        attachment: attachment,
                        comment: widget.comment!,
                      );
                    },
                  ),
                ],
              ),
            ),
          const Divider(),
           Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(  widget!.comment!.date!)
                      .add(Duration(hours: 3))),
                  style: const TextStyle(fontSize: 14.0),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVoteButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          isVoted = !isVoted; // Toggle the vote state
        });
        controller.voteComment(uid, widget.comment!.id!);
      },
      icon: Icon(
        isVoted ? Icons.favorite : Icons.favorite_border,
        color: isVoted
            ? Colors.red
            : Colors.red, // Use different colors for voted and not voted states
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
    return const AssetImage('assets/imgs/user.png');
  }
}

class AttachmentWidget extends StatefulWidget {
  final Attachment attachment;
  final Comment comment;

  AttachmentWidget({
    Key? key,
    required this.attachment,
    required this.comment,
  }) : super(key: key);

  @override
  State<AttachmentWidget> createState() => _AttachmentWidgetState();
}

class _AttachmentWidgetState extends State<AttachmentWidget> {
  final FileDownloadController downloadcontroller =
      Get.find<FileDownloadController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            widget.attachment.fileName!,
            maxLines: 5,
            overflow: TextOverflow.clip,
            style: const TextStyle(fontSize: 14.0),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.download,
            color: primarycolor,
          ),
          onPressed: () {
            String attachementid = widget.comment.attachmentIds!
                .toString()
                .substring(
                    1, widget.comment.attachmentIds!.toString().length - 1);
            SharedData.getFromStorage('parent', 'object', 'uid').then((uid) {
              downloadcontroller.downloadFile(
                uid,
                attachementid!,
                widget.attachment.fileName ?? '',
              );
            });
            if (kDebugMode) {
              print('here$attachementid');
            }
          },
        )
      ],
    );
  }
}
