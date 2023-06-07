import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/dowload_file_controller.dart';
import '../../../model/book_model.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/shared_preferences.dart';

class BookCard extends StatelessWidget {
  final Book? book;
  final FileDownloadController? downloadController;

  const BookCard(
      {Key? key,  this.book,  this.downloadController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 10,),
                Text(book!.period!.toString() ?? '',style: const TextStyle(fontWeight: FontWeight.bold),),
                const SizedBox(height: 10,),
                Text('${'moyenne'.tr}${book?.average ?? ''}'),

                if (book!.attachments!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: book!.attachments!.length,
                        itemBuilder: (context, index) {
                          final attachment = book!.attachments![index];
                          return Row(
                            children: [
                              Expanded(
                                child: Text(attachment.fileName ?? ''),
                              ),
                              IconButton(
                                icon:  Icon(Icons.download,
                                  color: primarycolor ,),
                                onPressed: () {
                                  SharedData.getFromStorage('parent', 'object', 'uid').then((uid) {
                                    downloadController!.downloadFile(
                                      uid,
                                      attachment.id.toString(),
                                      attachment.fileName ?? '',

                                    );
                                    if (kDebugMode) {
                                      print(attachment.id);
                                    }
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(book!.academic ?? ''),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}