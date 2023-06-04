import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/dowload_file_controller.dart';
import '../../../model/attachement_model.dart';
import '../../../model/comments_model.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/shared_preferences.dart';


class AttachmentWidget extends StatelessWidget {
  final FileDownloadController downloadcontroller =
  Get.find<FileDownloadController>();
  final Attachment attachment;
  final Comment comment;

  AttachmentWidget({
    Key? key,
    required this.attachment, required this.comment,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            attachment.fileName!,
            maxLines: 5,
            overflow: TextOverflow.clip,
            style: const TextStyle(fontSize: 14.0),
          ),
        ),
        IconButton(
          icon:  Icon(Icons.download,
            color: primarycolor ,),
          onPressed: () {
            String attachementid =  comment.attachmentIds!.toString().substring(1, comment.attachmentIds!.toString().length - 1);
            SharedData.getFromStorage('parent', 'object', 'uid').then((uid) {
              downloadcontroller.downloadFile(
                uid,
                attachementid!,
                attachment.fileName ?? '',
              );
            });
            if (kDebugMode) {
              print('here$attachementid');
            }
          },
        )
      ],
    );
  }
}