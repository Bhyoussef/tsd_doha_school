import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tsdoha/utils/shared_preferences.dart';
import '../../constant/constant.dart';
import '../../controller/message_controller/message_sent_controller.dart';
import '../../model/message_sent_model.dart';
import '../../theme/app_colors.dart';
import 'message_sent_details.dart';

class SentMessages extends StatefulWidget {
  const SentMessages({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final MessageSentController controller;

  @override
  State<SentMessages> createState() => _SentMessagesState();
}

class _SentMessagesState extends State<SentMessages> {
  Future<void> _refreshMessages() async {
    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
      await widget.controller.fetchingSentMessage(uid);
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
          : RefreshIndicator(
        onRefresh: _refreshMessages,
        color: primarycolor,
        child: ListView.builder(
          itemCount: widget.controller.sentedmessage.length,
          itemBuilder: (context, index) {
            MessageSent message = widget.controller.sentedmessage[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => MessageSentDetails(message: message));
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: MessageCardSent(
                  title: message.name ?? '',
                  receiver: message.receiver ?? '',
                  message: message.message ?? '',
                  date: message.date ?? '',
                  uploadedfile: message.uploadFile ?? '',
                ),
              ),
            );
          },
        ),
      )),
    );
  }
}


class MessageCardSent extends StatelessWidget {
  final String? title;
  final String? receiver;
  final String? message;
  final String? date;
  final String? uploadedfile;

  const MessageCardSent({
    Key? key,
    this.title,
    this.receiver,
    this.message,
    this.date,
    this.uploadedfile,
  });

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
                const Icon(Icons.person),
                const SizedBox(width: 8.0),
                receiver == 'T'
                    ? Expanded(
                        child: Text(
                          'teacher'.tr,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      )
                    : Expanded(
                        child: Text(
                          'admin'.tr,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message!,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse( date!,)
                      .add(Duration(hours: 3))),
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          if (uploadedfile!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.attach_file),
                    SizedBox(width: 8.0),
                    Text('Download File'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
