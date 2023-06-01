import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../constant/constant.dart';
import '../../controller/message_controller/message_sent_controller.dart';
import '../../model/message_sent_model.dart';
import '../../model/send_message_model.dart';
import '../../routes/routes.dart';
import '../../theme/app_colors.dart';
import '../../utils/shared_preferences.dart';
import 'add_response.dart';

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
  void _refreshMessageDetails() {
    print(widget.message.id);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      controller.getsentmessagedetails(uid, widget.message.id!);
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
            child: GestureDetector(
              onTap: (){
                Get.toNamed(Routes.home);
              },
              child: Image.asset(
                'assets/imgs/tsdIcon.png',
                width: 40,
                height: 40,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
              () {
            if (controller.isLoading.value) {
              return  Center(
                child: CircularProgressBar(color: primarycolor,),
              );
            } else if (controller.detailssentmessage.isEmpty) {
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/imgs/notfound.png'),
                      const Text('No conversation history found')
                    ],
                  )
              );
            } else {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                 // MessageContentSent(message: widget.message),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                   /*   Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Response'.tr,
                          style: TextStyle(
                            color: primarycolor,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),*/
                    ],
                  ),
                  response()

                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) =>  AddResponse(message:widget.message,
                refreshCallback: _refreshMessageDetails),
          );
        },
        style: ElevatedButton.styleFrom(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          primary: primarycolor,
        ),
        child:  Text(
          'addResponse'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );



  }

  Widget response(){
    return  Obx(
          () {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressBar(
              color: primarycolor,
            ),
          );
        } else if (controller.detailssentmessage.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No conversation history found')
                ],
              ),
            ),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.detailssentmessage.length -1,
            itemBuilder: (context, index) {
              final messagelist = controller.detailssentmessage[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: MessageCardSent(messagelist),
              );
            },
          );
        }
      },
    );
  }
}


class MessageCardSent extends StatelessWidget {
  final SendMessage message;

  const MessageCardSent(this.message, { Key? key});

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

          message.attachmentName!.isEmpty?Container():Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: message.attachmentName!.length,
                    itemBuilder: (context, index) {
                      final attachmentName = message.attachmentName![index];
                      return Text(
                        attachmentName,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.download,
                    color: primarycolor,
                  ),
                  onPressed: () {

                  },
                ),
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
  final MessageSent? message;

  const MessageContentSent({Key? key,  this.message}) : super(key: key);

  @override
  State<MessageContentSent> createState() => _MessageContentSentState();
}

class _MessageContentSentState extends State<MessageContentSent> {
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
              widget.message!.name!,
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
              "${'to'.tr} : ${widget.message!.receiver!}",
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        /*  CircleAvatar(
            backgroundImage: MemoryImage(base64Decode(widget.message.uploadFile!)),
            radius: 40.0,
          ),*/
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _removeAllHtmlTags(widget.message!.message!),
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
         widget.message!.fileName! == "false"?Container(): Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.message!.fileName!,
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
                  onPressed: () {
                    _downloadFile(widget.message!.fileName!, widget.message!.uploadFile!);
                  },
                ),
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
                  widget.message!.date!,
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

  Future<void> _downloadFile(String fileName, String base64File) async {
    try {
      final bytes = base64Decode(base64File);
      final dir = await getExternalStorageDirectory();
      final filePath = '${dir!.path}/$fileName';
      File file = File(filePath);
      await file.writeAsBytes(bytes);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File downloaded successfully'),
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to download the file'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }
}
