import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/constant/constant.dart';
import 'package:tsdoha/controller/dowload_file_controller.dart';
import 'package:tsdoha/controller/message_controller/message_sent_controller.dart';
import 'package:tsdoha/model/message_sent_model.dart';
import 'package:tsdoha/model/send_message_model.dart';
import 'package:tsdoha/theme/app_colors.dart';
import 'package:tsdoha/utils/shared_preferences.dart';
import 'package:tsdoha/views/home/home_screen.dart';
import 'add_response.dart';

class MessageSentDetails extends StatefulWidget {
  final MessageSent message;
  const MessageSentDetails({Key? key, required this.message}) : super(key: key);

  @override
  State<MessageSentDetails> createState() => _MessageSentDetailsState();
}

class _MessageSentDetailsState extends State<MessageSentDetails> {
  final MessageSentController controller = Get.find<MessageSentController>();

  int uid = 0;

  Future<void> _fetchUid() async {
    final fetchedUid =
        await SharedData.getFromStorage('parent', 'object', 'uid');
    setState(() {
      uid = fetchedUid;
      if (kDebugMode) {
        print(uid);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUid();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      controller.getsentmessagedetails(uid, widget.message.id!);
    });
  }

  @override
  void dispose() {
    controller.isloading.value = false;
    controller.detailssentmessage.clear();
    super.dispose();
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
            Navigator.pop(context);
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
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => controller.isloading.isTrue
              ? Center(
                  child: CircularProgressBar(
                    color: primarycolor,
                  ),
                )
              : controller.detailssentmessage.isNotEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [],
                        ),
                        response()
                      ],
                    )
                  : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/imgs/notfound.png'),
                        Text('noconversationfound'.tr)
                      ],
                    )))),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Get.to(
            () => AddResponse(
              message: widget.message,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          primary: primarycolor,
        ),
        child: Text(
          'addResponse'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget response() {
    return Obx(
      () {
        if (controller.isLoading.isTrue) {
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
                children: [Text('noconversationfound'.tr)],
              ),
            ),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.detailssentmessage.length - 1,
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

class MessageCardSent extends StatefulWidget {
  final SendMessage message;

  const MessageCardSent(this.message, {Key? key});

  @override
  State<MessageCardSent> createState() => _MessageCardSentState();
}

class _MessageCardSentState extends State<MessageCardSent> {
  final FileDownloadController controller = Get.find<FileDownloadController>();
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
            padding: const EdgeInsets.all(0.0),
            child: Text(
              widget.message.displayName!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              "${'to'.tr} : ${widget.message.authorId!}",
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              _removeAllHtmlTags(widget.message.message!),
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          widget.message.attachmentName!.isEmpty
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: widget.message.attachmentName!.length,
                        itemBuilder: (context, index) {
                          final attachmentName =
                              widget.message.attachmentName![index];
                          final attachmentId =
                              widget.message.attachmentIds![index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  attachmentName,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.download,
                                  color: primarycolor,
                                ),
                                onPressed: () {
                                  final cleanedBase64Image =
                                      attachmentId.replaceAll('\n', '');
                                  controller.download(
                                      cleanedBase64Image, attachmentName);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
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
