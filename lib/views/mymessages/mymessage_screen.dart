import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/controller/dowload_file_controller.dart';
import 'package:tsdoha/controller/message_controller/message_received_controller.dart';
import 'package:tsdoha/controller/message_controller/message_sent_controller.dart';
import 'package:tsdoha/theme/app_colors.dart';
import 'package:tsdoha/views/sendmessage/sendmessage_screen.dart';
import 'message_received.dart';
import 'message_sent.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late FileDownloadController downloadController;
  final controllerreceivedmessage = Get.find<MessageReceivedController>();
  final controllersentmessage = Get.find<MessageSentController>();
  int uid = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    downloadController = Get.put(FileDownloadController());
  }

  @override
  void dispose() {
    controllersentmessage.isLoading.value = false;
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
            labelStyle: const TextStyle(
                color: CupertinoColors.white, fontWeight: FontWeight.bold),
            indicator: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: CupertinoColors.white,
                  width: 3.0,
                ),
              ),
            ),
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
          ReceivedMessages(
              controller: controllerreceivedmessage,
              downloadController: downloadController,
              uid: uid),
          SentMessages(controller: controllersentmessage),
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
}
