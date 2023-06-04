import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../constant/constant.dart';
import '../../controller/message_controller/send_message_controller.dart';
import '../../model/personal_model.dart';
import '../../theme/app_colors.dart';
import '../../utils/shared_preferences.dart';

class SendMessageScreen extends StatefulWidget {
  SendMessageScreen({Key? key}) : super(key: key);

  @override
  State<SendMessageScreen> createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {

  final SendMessageController controller = Get.put(SendMessageController());
  final TextEditingController toController = TextEditingController();
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final RxString attachmentPath = RxString('');
  int uid = 0;

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
    });
  }

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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/imgs/tsdIcon.png',
              width: 40,
              height: 40,
            ),
          ),
        ],
        title: Text(
          'sendmessage'.tr,
          style: const TextStyle(
              color: CupertinoColors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: CupertinoColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                  String receiverId = '0';

                  if (toController.text == 'T') {
                    final selectedTeacher =
                        controller.teacherRecipients.firstWhere(
                      (teacher) => teacher.name == recipientController.text,
                      orElse: () => Personal(),
                    );
                    receiverId = selectedTeacher.id?.toString() ?? '0';
                  } else if (toController.text == 'A') {
                    final selectedAdmin = controller.adminRecipients.firstWhere(
                      (admin) => admin.name == recipientController.text,
                      orElse: () => Personal(),
                    );
                    receiverId = selectedAdmin.id?.toString() ?? '0';
                  }
                  controller.createMessage(
                      uid,
                      toController.text,
                      subjectController.text,
                      messageController.text,
                      receiverId,
                      attachmentPath.value.toString());
                },
                child: Text(
                  'send'.tr,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.white),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(() => controller.isLoading.value
                  ? Center(
                      child: CircularProgressBar(
                      color: primarycolor,
                    ))
                  : Container()),
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
          'to'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Obx(() => RadioListTile<String>(
              activeColor: primarycolor,
              title: Text('teacher'.tr),
              value: 'T',
              groupValue: controller.selectedTo.value,
              onChanged: (value) {
                toController.text = value!;
                controller.selectedTo.value = value;
                SharedData.getFromStorage('parent', 'object', 'uid')
                    .then((uid) async {
                  controller.fetchRecipients(uid);
                });
                controller.recipientVisible.value = true;
              },
            )),
        Obx(() => RadioListTile<String>(
              activeColor: primarycolor,
              title: Text('admin'.tr),
              value: 'A',
              groupValue: controller.selectedTo.value,
              onChanged: (value) {
                toController.text = value!;
                controller.selectedTo.value = value;
                SharedData.getFromStorage('parent', 'object', 'uid')
                    .then((uid) async {
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
      return Obx(() => SingleChildScrollView(
            child: ListView(
              shrinkWrap: true,
              children: [
                DropdownButtonFormField<String>(
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
                  decoration: InputDecoration(
                    labelText: 'receiver'.tr,
                  ),
                  key: ValueKey(controller.selectedTo.value),
                ),
              ],
            ),
          ));
    });
  }

  Widget _buildSubjectField() {
    return TextField(
      controller: subjectController,
      onChanged: (value) {
        controller.subject.value = value;
      },
      decoration: InputDecoration(
        labelText: 'subject'.tr,
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
      decoration: InputDecoration(
        labelText: 'message'.tr,
      ),
    );
  }

  Widget _buildAttachmentList() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'attachemnts'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (attachmentPath.value.isNotEmpty)
            Row(
              children: [
                Expanded(
                  child: Text(
                    attachmentPath.value.split('/').last,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    attachmentPath.value = '';
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildAddAttachmentButton() {
    return MaterialButton(
      minWidth: double.infinity,
      height: 50,
      color: primarycolor,
      textColor: Colors.white,
      onPressed: () {
        showAttachmentSelectionDialog();
      },
      child: Text(
        'addattachment'.tr,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  void showAttachmentSelectionDialog() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      attachmentPath.value = pickedFile.path;
    }
  }
}
