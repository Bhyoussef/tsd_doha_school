import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:tsdoha/constant/constant.dart';
import 'package:tsdoha/controller/message_controller/message_received_controller.dart';
import 'package:tsdoha/model/message_model.dart';
import 'package:tsdoha/theme/app_colors.dart';
import 'package:tsdoha/utils/keyboard.dart';
import 'package:tsdoha/utils/shared_preferences.dart';

class AddCommentPage extends StatefulWidget {
  final Message? message;
  const AddCommentPage({Key? key, this.message}) : super(key: key);

  @override
  _AddCommentPageState createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  final TextEditingController commentController = TextEditingController();
  final MessageReceivedController controller =
      Get.put(MessageReceivedController());
  final RxString? attachmentPath = RxString('');

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
      print(uid);
      print(widget.message!.iD.toString());
      print(commentController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primarycolor,
        automaticallyImplyLeading: false,
        title: Text(
          'addcomment'.tr,
          style: const TextStyle(
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
      body: GestureDetector(
        onTap: () => KeyboardUtil.hideKeyboard(context),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                cursorColor: primarycolor,
                controller: commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'writeyourcomment'.tr,
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
                  if (commentController.text.isEmpty || attachmentPath!.value.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('fieldarerequired'.tr),
                        backgroundColor: primarycolor,
                      ),
                    );
                  } else {
                    controller.addCommentWithAttachment(
                      commentController.text,
                      widget.message!.iD!,
                      attachmentPath!.value.toString(),
                      uid,
                    );
                  }
                },


                child: Text(
                  'send'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
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

  Widget _buildAttachmentList() {
    return Obx(
          () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'attachments'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (attachmentPath!.value.isNotEmpty)
            Row(
              children: [
                Expanded(
                  child: Text(
                    path.basename(attachmentPath!.value),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    attachmentPath!.value = '';
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
    final filePicker = FilePicker.platform;
    final file = await filePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'], // Add the desired file extensions here
    );

    if (file != null) {
      attachmentPath!.value = file.files.single.path!;
    }
  }
}
