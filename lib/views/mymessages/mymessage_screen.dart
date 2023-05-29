import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/message_controller/message_received_controller.dart';
import '../../controller/message_controller/message_sent_controller.dart';
import '../../controller/mychildren_controller/dowload_file_controller.dart';
import '../../model/message_model.dart';
import '../../model/message_sent_model.dart';
import '../../theme/app_colors.dart';
import '../sendmessage/sendmessage_screen.dart';
import 'details_message.dart';
import 'message_sent_details.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

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
    return GetBuilder<MessageReceivedController>(
      builder: (controller) {
        if (controller.isLoading.value) {
          return  Center(
            child: CircularProgressIndicator(color: primarycolor,),
          );
        } else if (controller.receivedMessage.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/imgs/notfound.png'),
              const Text('No message received found'),
            ],
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: ListView.builder(
              itemCount: controller.receivedMessage.length,
              itemBuilder: (context, index) {
                Message message = controller.receivedMessage[index];
                return GestureDetector(
                  onTap: () {
                    if (message.state != 'read') {
                      // Update the message state to 'read'
                      //controller.updateMessageState(message.id);
                    }
                    Get.to(() => DetailsMessageReceived(message: message,downloadController: downloadController,));
                    if (kDebugMode) {
                      print(message.iD);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MessageCardReceived(
                      title: message.titleOfMessage ?? '',
                      image: message.teacherImage ?? '',
                      sender: message.teacher ?? '',
                      message: message.message ?? '',
                      details: '${message.student ?? ''} • ${message.date ?? ''}',
                      isRead: message.state ?? '',
                      isAttached: message.attachments!.isEmpty,
                      attachments: message.attachments!,
                      downloadController: downloadController,
                    ),
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/imgs/notfound.png'),
              const Text('No sent messages Found'),
            ],
          );
        } else {
          return ListView.builder(
            itemCount: controller.sentedmessage.length,
            itemBuilder: (context, index) {
              MessageSent message = controller.sentedmessage[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    Get.to(()=>MessageSentDetails(message:message));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MessageCardSent(
                      title: message.name ?? '',
                      receiver: message.receiver ?? '',
                      message: message.message ?? '',
                      date: message.date ?? '',
                    ),
                  ),
                ),
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
           /*   if (attachments.isNotEmpty)
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
                ),*/
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
