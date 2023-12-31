import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:tsdoha/constant/constant.dart';
import 'package:tsdoha/controller/message_controller/send_message_controller.dart';
import 'package:tsdoha/model/personal_model.dart';
import 'package:tsdoha/theme/app_colors.dart';
import 'package:tsdoha/utils/keyboard.dart';
import 'package:tsdoha/utils/shared_preferences.dart';
import 'package:tsdoha/views/home/home_screen.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            child: GestureDetector(
              onTap: () {
                Get.offAll(HomeScreen());
              },
              child: Image.asset(
                'assets/imgs/tsdIcon.png',
                width: 40,
                height: 40,
              ),
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
      body: GestureDetector(
        onTap: () => KeyboardUtil.hideKeyboard(context),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Form(
              key: _formKey,
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
                      if ( attachmentPath!.value.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('fieldarerequired'.tr),
                            backgroundColor: primarycolor,
                          ),
                        );
                      } else {
                        if (_formKey.currentState!.validate()) {
                          String receiverId = '0';

                          if (toController.text == 'T') {
                            final selectedTeacher = controller.teacherRecipients
                                .firstWhere((teacher) =>
                            teacher.name == recipientController.text,
                                orElse: () => Personal());
                            receiverId =
                                selectedTeacher.id?.toString() ?? '0';
                          } else if (toController.text == 'A') {
                            final selectedAdmin = controller.adminRecipients
                                .firstWhere((admin) =>
                            admin.name == recipientController.text,
                                orElse: () => Personal());
                            receiverId =
                                selectedAdmin.id?.toString() ?? '0';
                          }
                          controller.createMessage(
                            uid,
                            toController.text,
                            subjectController.text,
                            messageController.text,
                            receiverId,
                            attachmentPath.value.toString(),
                          );
                        }
                      }
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
                    ),
                  )
                      : Container()),
                ],
              ),
            ),
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
                labelStyle: TextStyle(
                    color: primarycolor, fontWeight: FontWeight.bold),
              ),
              key: ValueKey(controller.selectedTo.value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a recipient.';
                }
                return null;
              },
            ),
          ],
        ),
      ));
    });
  }

  Widget _buildSubjectField() {
    return TextFormField(
      cursorColor: primarycolor,
      controller: subjectController,
      onChanged: (value) {
        controller.subject.value = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'pleaseenterasubject'.tr;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'subject'.tr,
        labelStyle: TextStyle(
            color: primarycolor, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMessageField() {
    return TextFormField(
      cursorColor: primarycolor,
      controller: messageController,
      onChanged: (value) {
        controller.message.value = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'pleaseenteramessage'.tr;
        }
        return null;
      },
      maxLines: 6,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: 'message'.tr,
        labelStyle: TextStyle(
            color: primarycolor, fontWeight: FontWeight.bold),
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
                    path.basename(attachmentPath.value),
                    style: const TextStyle(fontSize: 16),
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
    showDialog(
      context: Get.overlayContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('selectattatchement'.tr,  style: TextStyle(
            color: primarycolor,
            fontWeight: FontWeight.bold,
          ),),
          content: Text('onlytype'.tr,  style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('cancel'.tr,  style: TextStyle(
                color: primarycolor,
                fontWeight: FontWeight.bold,
              ),),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final filePicker = FilePicker.platform;
                final file = await filePicker.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf', 'doc', 'docx'],
                );

                if (file != null) {
                  attachmentPath.value = file.files.single.path!;
                }
              },
              child: Text('choosefile'.tr,  style: TextStyle(
                color: primarycolor,
                fontWeight: FontWeight.bold,
              ),),
            ),
          ],
        );
      },
    );
  }
}
