import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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


  int uid=0;
  @override
  void initState() {
    super.initState();
    _fetchUid();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getsentmessagedetails(uid, widget.message.id!);
    });
  }
  Future<void> _fetchUid() async {
    final fetchedUid = await SharedData.getFromStorage('parent', 'object', 'uid');
    setState(() {
      uid = fetchedUid;
      print(uid);
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
        title:  Text(
          'messagedetails'.tr,
          style: const TextStyle(
              color: CupertinoColors.white, fontWeight: FontWeight.bold),
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
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressBar(
                color: primarycolor,
              ),
            );
          } else if (controller.detailssentmessage.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/imgs/notfound.png'),
                const Text('No Messages Found')
              ],
            ));
          } else {
            return ListView.builder(
                itemCount: controller.detailssentmessage.length,
                itemBuilder: (context, index) {
                  final messagelist = controller.detailssentmessage[index];
                  return MessageCardSent(messagelist);
                });
          }
        },
      ),
    );
  }
}

class MessageCardSent extends StatelessWidget {
  final SendMessage message;

  const MessageCardSent(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
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
              'To: ${message.authorId}',
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
