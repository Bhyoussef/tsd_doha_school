import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tunisian_school_doha/theme/app_colors.dart';
import '../../controller/message_controller/message_received_controller.dart';
import '../../controller/message_controller/message_sent_controller.dart';
import '../../controller/mychildren_controller/dowload_file_controller.dart';
import '../../model/message_model.dart';
import '../../model/message_sent_model.dart';
import '../sendmessage/sendmessage_screen.dart';
import 'details_message.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late FileDownloadController downloadController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    downloadController = Get.put(FileDownloadController());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Material(
        color: primarycolor,
        child: SafeArea(
          child: TabBar(
            labelColor: Colors.white,
            indicatorColor: CupertinoColors.white,
            automaticIndicatorColorAdjustment: true,
            indicatorWeight: 3.0,

            controller: _tabController,
            tabs: [
              Tab(
                text: 'recieved'.tr,
              ),
              Tab(
                text: 'sent'.tr,
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReceivedMessages(),
          _buildSentMessages(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => SendMessageScreen());
        },
        backgroundColor: const Color(0xFFbe052d),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildReceivedMessages() {
    return GetBuilder<MesaageReceivedController>(
      builder: (controller) {
        if (controller.isLoading.value) {
          return  Center(
            child: CircularProgressIndicator(color: primarycolor,),
          );
        } else if (controller.receivedmessage.isEmpty) {
          return const Center(
            child: Text('No received messages'),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: ListView.builder(
              itemCount: controller.receivedmessage.length,
              itemBuilder: (context, index) {
                Message message = controller.receivedmessage[index];
                return GestureDetector(
                  onTap: () {
                    if (message.state != 'read') {
                      // Update the message state to 'read'
                      //controller.updateMessageState(message.id);
                    }
                    Get.to(() => DetailsMessage(message: message));
                    print(message.iD);
                  },
                  child: MessageCardReceived(
                    title: message.titleOfMessage ?? '',
                    image: message.teacherImage ?? '',
                    sender: message.teacher ?? '',
                    message: message.message ?? '',
                    details: '${message.student ?? ''} • ${message.date ?? ''}',
                    isRead: message.state ?? '',
                    isAttached: message.attachments!.isEmpty!,
                    attachments: message.attachments!,
                    downloadController: downloadController,
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildSentMessages() {
    return GetBuilder<MesaageSentController>(
      builder: (controller) {
        if (controller.isLoading.value) {
          return  Center(
            child: CircularProgressIndicator(color: primarycolor,),
          );
        } else if (controller.sentedmessage.isEmpty) {
          return const Center(
            child: Text('No sent messages'),
          );
        } else {
          return ListView.builder(
            itemCount: controller.sentedmessage.length,
            itemBuilder: (context, index) {
              MessageSent message = controller.sentedmessage[index];
              return MessageCardSent(
                title: message.name ?? '',
                receiver: message.receiver ?? '',
                message: message.message ?? '',
                date: message.date ?? '',
              );
            },
          );
        }
      },
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

  const MessageCardReceived({
    Key? key,
    required this.title,
    required this.image,
    required this.sender,
    required this.message,
    required this.details,
    required this.isRead,
    required this.isAttached,
    required this.attachments,
    required this.downloadController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMessageRead = isRead == 'read';

    return Card(
      elevation: isMessageRead ? 2.0 : 2.0,
      shape: isMessageRead
          ? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.grey.withOpacity(0.5)),
      )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.grey.withOpacity(0.5)),
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
                      radius: 20.0,
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
                      const Text(
                        'Attachments:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: attachments.length,
                        itemBuilder: (context, index) {
                          final attachment = attachments[index];
                          return Text(
                            attachment.fileName ?? '',
                            style: const TextStyle(fontSize: 14.0),
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
          Positioned(
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
              : Positioned(
                  top: 8.0,
                  right: 25.0,
                  child: Icon(Icons.attach_file),
                ),
        ],
      ),
    );
  }
}

class MessageCardSent extends StatelessWidget {
  final String title;
  final String receiver;
  final String message;
  final String date;

  const MessageCardSent({
    required this.title,
    required this.receiver,
    required this.message,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
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
            child: Text(
              'To: $receiver',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
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
                  date,
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
