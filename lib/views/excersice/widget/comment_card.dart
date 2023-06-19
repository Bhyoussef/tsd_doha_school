import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/controller/exercise/exercise_controller.dart';
import 'package:tsdoha/model/comments_model.dart';
import 'package:tsdoha/utils/shared_preferences.dart';
import 'attachement_card.dart';

class CommentCard extends StatefulWidget {
  final Comment? comment;

  const CommentCard({
    Key? key,
    this.comment,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final ExerciseController controller =
  Get.find<ExerciseController>();
  int uid = 0;
  bool isVoted = false;

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
      isVoted = widget.comment!.voteUserIds!.contains(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.comment!.recordName!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              buildVoteButton()
            ],
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                  _buildCircleAvatar(widget.comment!.authorId!.image!),
                  radius: 30.0,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    widget.comment!.authorId!.name!,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _removeAllHtmlTags(widget.comment!.body!),
              maxLines: 5,
            ),
          ),

          if (widget.comment!.attachments != null &&
              widget.comment!.attachments!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'attachemnts'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: widget.comment!.attachments!
                        .map((attachment) => AttachmentWidget(
                      attachment: attachment,
                      comment: widget.comment!,
                    ))
                        .toList(),
                  ),
                ],
              ),
            ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVoteButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          isVoted = !isVoted;
        });
        controller.voteComment(uid, widget.comment!.id!);
      },
      icon: Icon(
        isVoted ? Icons.favorite : Icons.favorite_border,
        color: isVoted
            ? Colors.red
            : Colors.red,
      ),
    );
  }

  String _removeAllHtmlTags(String htmlText) {
    if (htmlText == null) return 'N/A';
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }

  ImageProvider _buildCircleAvatar(dynamic image) {
    if (image != null) {
      try {
        final decodedImage = base64Decode(image.toString());

        return MemoryImage(decodedImage);
      } catch (e) {
        if (kDebugMode) {
          print('Invalid image data: $e');
        }
      }
    }
    return const AssetImage('assets/imgs/user-avatar.png');
  }
}