import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tsdoha/utils/shared_preferences.dart';
import '../../constant/constant.dart';
import '../../controller/dowload_file_controller.dart';
import '../../controller/message_controller/message_received_controller.dart';
import '../../model/message_model.dart';
import '../../theme/app_colors.dart';
import 'message_received_details.dart';

class ReceivedMessages extends StatefulWidget {
  const ReceivedMessages({
    Key? key,
    required this.controller,
    required this.downloadController,
    this.uid,
  }) : super(key: key);

  final MessageReceivedController controller;
  final FileDownloadController downloadController;
  final int? uid;

  @override
  State<ReceivedMessages> createState() => _ReceivedMessagesState();
}

class _ReceivedMessagesState extends State<ReceivedMessages> {
  Future<void> _refreshMessages() async {
    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
      await widget.controller.fetchReceivedMessage(uid);
    });
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() => widget.controller.isLoading.isTrue
          ? Center(child: CircularProgressBar(color: primarycolor))
          : widget.controller.receivedMessage.isNotEmpty
          ? RefreshIndicator(
        color: primarycolor,
        onRefresh: _refreshMessages,
        child: ListView.builder(
          itemCount: widget.controller.receivedMessage.length,
          itemBuilder: (context, index) {
            Message message = widget.controller.receivedMessage[index];
            return GestureDetector(
              onTap: () {
                if (message.state != 'read') {
                  widget.controller.updateMessageState(widget.uid!, message.iD!);
                  print('youssef' + widget.uid.toString());
                }
                Get.to(() => DetailsMessageReceived(
                  message: message,
                  messageid: message.iD,
                  downloadController: widget.downloadController,
                ));
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: MessageCardReceived(
                  title: message.titleOfMessage ?? '',
                  image: message.teacherImage ?? '',
                  sender: message.teacher ?? '',
                  message: message.message ?? '',
                  details: '${message.student ?? ''} • ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(message.date!).add(Duration(hours: 3)))}',
                  isRead: message.state ?? '',
                  isAttached: message.attachments!.isEmpty,
                  attachments: message.attachments!,
                  downloadController: widget.downloadController,
                ),
              ),
            );
          },
        ),
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/imgs/notfound.png'),
          const Text('No message received found'),
        ],
      )),
    );
  }
}


class MessageCardReceived extends StatelessWidget {
  final String? title;
  final String? image;
  final String? sender;
  final String? message;
  final String? details;
  final String? isRead;
  final bool? isAttached;
  final List<Attachments>? attachments;
  final FileDownloadController? downloadController;

  const MessageCardReceived({
    Key? key,
    this.title,
    this.image,
    this.sender,
    this.message,
    this.details,
    this.isRead,
    this.isAttached,
    this.attachments,
    this.downloadController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Get.locale;
    final isArabic = locale?.languageCode == 'ar';
    bool isMessageRead = isRead == 'read';
    return Container(
      decoration: BoxDecoration(
        color: isMessageRead ? Colors.white : Color(0xffececec),
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
                  title!,
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
                      backgroundImage: MemoryImage(base64Decode(image!)),
                      radius: 30.0,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        sender!,
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
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      details!,
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
          isAttached!
              ? Container()
              : isArabic == true
                  ? const Positioned(
                      top: 8.0,
                      left: 25.0,
                      child: Icon(Icons.attach_file),
                    )
                  : const Positioned(
                      top: 8.0,
                      right: 25.0,
                      child: Icon(Icons.attach_file),
                    ),
        ],
      ),
    );
  }
}
