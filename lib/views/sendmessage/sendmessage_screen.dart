import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/message_controller/send_message_controller.dart';
import '../../model/personal_model.dart';
import '../../theme/app_colors.dart';
import '../../utils/shared_preferences.dart';

class SendMessageScreen extends StatelessWidget {
  final SendMessageController controller = Get.put(SendMessageController());
  final TextEditingController toController = TextEditingController();
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  SendMessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
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
          'Send Message',
          style: TextStyle(
              color: CupertinoColors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: CupertinoColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildToField(),
              const SizedBox(height: 20),
              Obx(() {
                if (controller.selectedTo.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Visibility(
                  visible: controller.recipientVisible.value,
                  child: _buildRecipientField(),
                );
              }),
              const SizedBox(height: 20),
              _buildSubjectField(),
              const SizedBox(height: 20),
              _buildMessageField(),
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
                  final selectedTo = toController.text;
                  final selectedRecipient = recipientController.text;
                  final subject = subjectController.text;
                  final message = messageController.text;
                  final attachments = controller.attachmentControllers;

                  String receiverId = '0';

                  if (selectedTo == 'T') {
                    final selectedTeacher = controller.teacherRecipients.firstWhere(
                          (teacher) => teacher.name == selectedRecipient,
                      orElse: () => Personal(),
                    );
                    receiverId = selectedTeacher.id?.toString() ?? '0';
                  } else if (selectedTo == 'A') {
                    final selectedAdmin = controller.adminRecipients.firstWhere(
                          (admin) => admin.name == selectedRecipient,
                      orElse: () => Personal(),
                    );
                    receiverId = selectedAdmin.id?.toString() ?? '0';
                  }

                  SharedData.getFromStorage('parent', 'object', 'uid').then((uid) {
                    controller.sendMessage(
                      uid,
                      selectedTo,
                      subject,
                      message,
                      receiverId,
                      attachments as List<String>,
                    );
                  });
                },
                child: const Text(
                  'Send',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'To',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Obx(() => RadioListTile<String>(
          activeColor: primarycolor,
          title: const Text('Teacher'),
          value: 'T',
          groupValue: controller.selectedTo.value,
          onChanged: (value) {
            toController.text = value!;
            controller.selectedTo.value = value;
            SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
              controller.fetchRecipients(uid);
            });
            controller.recipientVisible.value = true;
          },
        )),
        Obx(() => RadioListTile<String>(
          activeColor: primarycolor,
          title: const Text('Administrator'),
          value: 'A',
          groupValue: controller.selectedTo.value,
          onChanged: (value) {
            toController.text = value!;
            controller.selectedTo.value = value;
            SharedData.getFromStorage('parent', 'object', 'uid').then((uid) async {
              controller.fetchRecipients(uid);
            });
            controller.recipientVisible.value = true;
          },
        )),
      ],
    );
  }

  Widget _buildRecipientField() {
    return Obx(() {
      final List<String?> recipients = controller.selectedTo.value == 'T'
          ? controller.teacherRecipients
          .map((personal) => personal.name)
          .toSet()
          .toList()
          : controller.adminRecipients
          .map((personal) => personal.name)
          .toSet()
          .toList();
      if (!recipients.contains(recipientController.text)) {
        if (recipients.isNotEmpty) {
          recipientController.text = recipients.first!;
        } else {
          recipientController.text = '';
        }
      }
      return Obx(() => DropdownButtonFormField<String>(
        value: recipientController.text,
        onChanged: (value) {
          recipientController.text = value!;
        },
        items: recipients
            .map(
              (recipient) => DropdownMenuItem(
            value: recipient,
            child: Text(recipient!),
          ),
        )
            .toList(),
        decoration: const InputDecoration(
          labelText: 'Recipient',
        ),
        key: ValueKey(controller.selectedTo.value),
      ));
    });
  }

  Widget _buildSubjectField() {
    return TextField(
      controller: subjectController,
      onChanged: (value) {
        controller.subject.value = value;
      },
      decoration: const InputDecoration(
        labelText: 'Subject',
      ),
    );
  }

  Widget _buildMessageField() {
    return TextField(
      controller: messageController,
      onChanged: (value) {
        controller.message.value = value;
      },
      maxLines: 6,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
        labelText: 'Message',
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
        Obx(() => ListView.builder(
          shrinkWrap: true,
          itemCount: controller.attachmentControllers.length,
          itemBuilder: (context, index) {
            final attachmentController = controller.attachmentControllers[index];
            return Row(
              children: [
                Expanded(
                  child: Text(
                    attachmentController.text,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    controller.removeAttachment(index);
                  },
                ),
              ],
            );
          },
        )),
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
}
