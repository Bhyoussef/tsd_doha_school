import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/model/message_sent_model.dart';
import 'package:tsdoha/utils/keyboard.dart';
import '../../constant/constant.dart';
import '../../controller/message_controller/message_sent_controller.dart';
import '../../theme/app_colors.dart';
import '../../utils/shared_preferences.dart';

class AddResponse extends StatefulWidget {
  final MessageSent? message;
  final Function? refreshCallback;
  const AddResponse({Key? key, this.message, this.refreshCallback})
      : super(key: key);

  @override
  State<AddResponse> createState() => _AddResponseState();
}

class _AddResponseState extends State<AddResponse> {
  final TextEditingController responsecontroller = TextEditingController();
  final MessageSentController controller = Get.put(MessageSentController());
  final RxString attachmentPath = RxString('');

  int uid = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchUid();
  }

  Future<void> _fetchUid() async {
    final fetchedUid = await SharedData.getFromStorage('parent', 'object', 'uid');
    setState(() {
      uid = fetchedUid;
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
          'addResponse'.tr,
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    cursorColor: primarycolor,
                    controller: responsecontroller,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'writeyourcomment'.tr,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'pleaseaddcomment'.tr;
                      }
                      return null;
                    },
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

                        if (_formKey.currentState!.validate()) {
                          if (attachmentPath.value.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('fieldarerequired'.tr),
                                backgroundColor: primarycolor,
                              ),
                            );
                          } else {
                            controller.addCommentWithAttachment(
                              responsecontroller.text,
                              widget.message!.id!,
                              attachmentPath.value.toString(),
                              uid,
                            );
                          }
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
                    child: CircularProgressBar(color: primarycolor),
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

  Widget _buildAttachmentList() {
    return Obx(
          () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (attachmentPath.value.isNotEmpty)
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
