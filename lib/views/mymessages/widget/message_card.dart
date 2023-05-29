import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../controller/mychildren_controller/dowload_file_controller.dart';
import '../../../model/message_model.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/shared_preferences.dart';



class MessageCardReceived extends StatelessWidget {
  final String title;
  final String image;
  final String sender;
  final String message;
  final String details;
  final String isRead;
  final bool isAttached;
  final List<Attachments> attachments;


  const MessageCardReceived({super.key,
    required this.title,
    required this.image,
    required this.sender,
    required this.message,
    required this.details,
    required this.isRead,
    required this.isAttached,
    required this.attachments,

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.grey.withOpacity(0.5)),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: MemoryImage(base64Decode(image)),
                        radius: 40.0,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          sender,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 16.0, color: Colors.black),
                      children: [
                        TextSpan(
                          text: message,
                        ),
                      ],
                    ),
                  ),
                ),
                if (attachments.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Attachments:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: attachments.length,
                          itemBuilder: (context, index) {
                            final attachment = attachments[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  attachment.fileName ?? '',
                                  style: const TextStyle(fontSize: 14.0),
                                ),
                                IconButton(
                                  icon:  Icon(Icons.download,
                                    color: primarycolor ,),
                                  onPressed: () {

                                    SharedData.getFromStorage('parent', 'object', 'uid').then((uid) {
                                    /*  downloadController.downloadFile(
                                        uid,
                                        attachment.id.toString(),
                                        attachment.fileName ?? '',
                                      );*/
                                    });
                                    print('here${attachment.id}');
                                  },
                                )
                              ],
                            );
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
                        details,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8.0,
              right: 8.0,
              child: Container(
                width: 12.0,
                height: 12.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isRead =='read'  ? Colors.green : Colors.red,
                ),
              ),
            ),
            isAttached ? Container() : const Positioned(
              top: 8.0,
              right: 25.0,
              child: Icon(Icons.attach_file,),
            ),
          ],
        ),
      ),
    );
  }
}



class MessageCardSent extends StatelessWidget {
  final String title;
  final String receiver;
  final String message;
  final String date;

  const MessageCardSent({
    required this.title,
    required this.receiver,
    required this.message,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
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
              'To: $receiver',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
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
                  date,
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}