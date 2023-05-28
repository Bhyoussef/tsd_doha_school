import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/message_controller/message_received_controller.dart';
import '../../theme/app_colors.dart';

class AddCommentPage extends StatefulWidget {
  const AddCommentPage({super.key});

  @override
  _AddCommentPageState createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  final TextEditingController commentController = TextEditingController();
  final MesaageReceivedController controller =
      Get.put(MesaageReceivedController());
  List<String> attachments = [];

  void addAttachment(String attachment) {
    setState(() {
      attachments.add(attachment);
    });
  }

  void removeAttachment(int index) {
    setState(() {
      attachments.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primarycolor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Add Comment',
          style: TextStyle(
              color: CupertinoColors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter your comment...',
              ),
            ),
            const SizedBox(height: 20),
            _buildAttachmentList(),
            const SizedBox(height: 20),
            _buildAddAttachmentButton(),
            const SizedBox(height: 20),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              height: 50,
              color: primarycolor,
              textColor: Colors.white,
              onPressed: () {
                //controller.addComments(uid, body, studentId)
              },
              child: const Text(
                'Send',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Attachments',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            itemCount: controller.attachmentControllers.length,
            itemBuilder: (context, index) {
              final attachmentController =
                  controller.attachmentControllers[index];
              final attachmentName = attachmentController.text
                  .split('/')
                  .last; // Extract the attachment name from the full path

              return Row(
                children: [
                  Expanded(
                    child: Text(
                      attachmentName,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.removeAttachment(index);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddAttachmentButton() {
    return MaterialButton(
      minWidth: double.infinity,
      height: 50,
      color: primarycolor,
      textColor: Colors.white,
      onPressed: () {
        controller.addAttachment();
      },
      child: const Text(
        'Add Attachment',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  void showAttachmentSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Attachment'),
          content: const Text('Attachment selection goes here...'),
          actions: [
            TextButton(
              onPressed: () {
                // Add attachment logic goes here...
                addAttachment('Attachment path...');
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void sendComment() {
    // Logic to send the comment goes here...
    final comment = commentController.text;
    // Send the comment and attachments to the appropriate destination
  }
}
