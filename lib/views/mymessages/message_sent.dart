import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../controller/message_controller/message_sent_controller.dart';
import '../../model/message_sent_model.dart';
import '../../theme/app_colors.dart';
import 'message_sent_details.dart';

class SentMessages extends StatelessWidget {
  const SentMessages({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final MessageSentController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() => controller.isLoading.isTrue
          ? Center(child: CircularProgressBar(color: primarycolor))
          : controller.sentedmessage.isNotEmpty
              ? ListView.builder(
                  itemCount: controller.sentedmessage.length,
                  itemBuilder: (context, index) {
                    MessageSent message = controller.sentedmessage[index];
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
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/imgs/notfound.png'),
                    const Text('No sent messages Found'),
                  ],
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
                  date!,
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
                  // Handle file download here
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
