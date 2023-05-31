import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../constant/constant.dart';
import '../../controller/message_controller/message_sent_controller.dart';
import '../../model/message_sent_model.dart';
import '../../model/send_message_model.dart';
import '../../theme/app_colors.dart';
import '../../utils/shared_preferences.dart';

class MessageSentDetails extends StatefulWidget {
  final MessageSent message;
  const MessageSentDetails({Key? key, required this.message}) : super(key: key);

  @override
  State<MessageSentDetails> createState() => _MessageSentDetailsState();
}

class _MessageSentDetailsState extends State<MessageSentDetails> {
  final MesaageSentController controller = Get.find<MesaageSentController>();

  int uid = 0;

  @override
  void initState() {
    super.initState();
    _fetchUid();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      controller.getsentmessagedetails(uid, widget.message.id!);
    });
  }

  Future<void> _fetchUid() async {
    final fetchedUid = await SharedData.getFromStorage('parent', 'object', 'uid');
    setState(() {
      uid = fetchedUid;
      if (kDebugMode) {
        print(uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: CupertinoColors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        backgroundColor: primarycolor,
        title: Text(
          'messagedetails'.tr,
          style: const TextStyle(
            color: CupertinoColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MessageContentSent(message: widget.message),
            Obx(
                  () {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressBar(
                      color: primarycolor,
                    ),
                  );
                } else if (controller.detailssentmessage.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:const  [
                          Text('No conversation history found')
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 400, // Provide a specific height for the inner ListView
                    child: ListView.builder(
                      itemCount: controller.detailssentmessage.length,
                      itemBuilder: (context, index) {
                        final messagelist = controller.detailssentmessage[index];
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: MessageCardSent(messagelist),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}


class MessageCardSent extends StatelessWidget {
  final SendMessage message;

  const MessageCardSent(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message.displayName!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${'to'.tr} : ${message.authorId!}",
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _removeAllHtmlTags(message.message!),
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  message.date!,
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  String _removeAllHtmlTags(String htmlText) {
    if (htmlText == null) return 'N/A';
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }
}




class MessageContentSent extends StatefulWidget {
  final MessageSent message;

  const MessageContentSent({Key? key, required this.message}) : super(key: key);

  @override
  State<MessageContentSent> createState() => _MessageContentSentState();
}

class _MessageContentSentState extends State<MessageContentSent> {


  Future<void> downloadFile() async {
    final base64FileData = widget.message.uploadFile;
    if (base64FileData != null) {
      final decodedBytes = base64.decode(base64FileData);
      final fileName = widget.message.fileName!;
      final directory = await getExternalStorageDirectory();

      final savedFile = File('${directory!.path}/$fileName');
      await savedFile.writeAsBytes(decodedBytes);

      await FlutterDownloader.enqueue(
        url: savedFile.path,
        savedDir: directory.path,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );
    }}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.message.name!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${'to'.tr} : ${widget.message.receiver!}",
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _removeAllHtmlTags(widget.message.message!),
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.message.fileName!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.download,
                    color: primarycolor,
                  ),
                  onPressed: downloadFile,
                )
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.message.date!,
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _removeAllHtmlTags(String htmlText) {
    if (htmlText == null) return 'N/A';
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }
}


