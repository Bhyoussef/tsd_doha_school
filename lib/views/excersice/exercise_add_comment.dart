import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tsdoha/constant/constant.dart';
import 'package:tsdoha/controller/exercise/exercise_controller.dart';
import 'package:tsdoha/model/exersice_model.dart';
import 'package:tsdoha/theme/app_colors.dart';
import 'package:tsdoha/utils/shared_preferences.dart';

class AddCommentExercise extends StatefulWidget {
  final Exersice? exercise;

  const AddCommentExercise({Key? key, this.exercise}) : super(key: key);

  @override
  _AddCommentPageState createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentExercise> {
  final TextEditingController commentController = TextEditingController();
  final ExerciseController controller = Get.put(ExerciseController());
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
        centerTitle: true,
        backgroundColor: primarycolor,
        automaticallyImplyLeading: false,
        title: Text(
          'addcomment'.tr,
          style: const TextStyle(
              color: CupertinoColors.white,
              fontWeight: FontWeight.bold),
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: commentController,
                maxLines: 5,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'pleaseaddcomment'.tr;
                  }
                  return null;
                },
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
                    if (_formKey.currentState!.validate()) {
                      _sendCommentWithAttachment();
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
                child: CircularProgressBar(
                  color: primarycolor,
                ),
              )
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
      onPressed: showAttachmentSelectionDialog,
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

  void _sendCommentWithAttachment() {
    if (attachmentPath.value.isEmpty || commentController.text.isEmpty) {
      final snackbar = SnackBar(
        backgroundColor: primarycolor,
        content: Text('fieldarerequired'.tr),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return;
    }

    // Additional attachment validation
    final List<String> allowedExtensions = ['pdf', 'doc', 'docx'];
    final String attachmentExtension =
    attachmentPath.value.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(attachmentExtension)) {
      final snackbar = SnackBar(
        backgroundColor: primarycolor,
        content: Text('Invalid attachment format.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return;
    }

    controller.addCommentWithAttachment(
      commentController.text,
      widget.exercise!.iD!,
      attachmentPath.value.toString(),
      uid,
    );
  }
}
