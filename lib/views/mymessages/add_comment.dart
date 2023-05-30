import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/message_controller/message_received_controller.dart';
import '../../model/message_model.dart';
import '../../theme/app_colors.dart';
import '../../utils/shared_preferences.dart';

class AddCommentPage extends StatefulWidget {
  final Message message;
  const AddCommentPage({Key? key, required this.message}) : super(key: key);

  @override
  _AddCommentPageState createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  final TextEditingController commentController = TextEditingController();
  final MessageReceivedController controller = Get.put(MessageReceivedController());
  final RxString attachmentPath = RxString('');


  int uid =0;

  @override
  void initState() {
    super.initState();
    _fetchUid();

  }

  Future<void> _fetchUid() async {
    final fetchedUid = await SharedData.getFromStorage('parent', 'object', 'uid');
    setState(() {
      uid = fetchedUid;
      print(uid);
      print(widget.message.iD.toString());
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
        title:  Text(
          'addcomment'.tr,
          style: const TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold),
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
              decoration:  InputDecoration(
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
               controller.addComment(
                   uid,
                   commentController.text,
                   widget.message.iD.toString());
                   //attachmentPath.value.toString());
               print(uid);
               print(widget.message.iD.toString());
               print(commentController.text);
              },
              child:  Text(
                'send'.tr,
                style:const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
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
            style:const  TextStyle(fontWeight: FontWeight.bold),
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
      child:  Text(
        'addattachment'.tr,
        style:const TextStyle(fontWeight: FontWeight.bold),
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
