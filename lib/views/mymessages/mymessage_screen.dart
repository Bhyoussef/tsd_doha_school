import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/message_controller/message_received_controller.dart';
import '../../controller/message_controller/message_sent_controller.dart';
import '../../model/message_model.dart';
import '../../model/message_sent_model.dart';
import '../sendmessage/sendmessage_screen.dart';
import 'details_message.dart';
import 'widget/message_card.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        color: const Color(0xFF6495ed),
        child: SafeArea(
          child: TabBar(
            labelColor: Colors.white,
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
        backgroundColor: const Color(0xFF6495ed),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildReceivedMessages() {
    return GetBuilder<MesaageReceivedController>(
      builder: (controller) {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.receivedmessage.isEmpty) {
          return const Center(
            child: Text('No received messages'),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: controller.receivedmessage.length,
              itemBuilder: (context, index) {
                Message message = controller.receivedmessage[index];
                return GestureDetector(
                  onTap: (){
                    Get.to(()=>DetailsMessage(message:message));
                  },
                  child: MessageCardReceived(
                    title: message.titleOfMessage ?? '',
                    image: message.teacherImage ?? '',
                    sender: message.teacher ?? '',
                    message: message.message ?? '',
                    details: '${message.student ?? ''} • ${message.date ?? ''}', isRead: message.state!,
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
          return const Center(
            child: CircularProgressIndicator(),
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


