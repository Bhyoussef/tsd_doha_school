import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../controller/mychildren_controller/dowload_file_controller.dart';
import '../../controller/mychildren_controller/mychildren_controller.dart';
import '../../model/book_model.dart';
import '../../utils/shared_preferences.dart';

class BookListScreen extends StatefulWidget {
  final int studentId;

  const BookListScreen({Key? key, required this.studentId}) : super(key: key);

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final ChildrenController controller = Get.find<ChildrenController>();
  final FileDownloadController downloadcontroller =
      Get.find<FileDownloadController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      controller.fetchBooksStudents(widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Color(0xFFB97CFC),),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        title: const Text('Books',style: TextStyle(
            color: Color(0xFF7590d6)
        ),),
      ),
      body: GetBuilder<ChildrenController>(
        builder: (bookController) {
          if (bookController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (bookController.books.isEmpty) {
            return const Center(
              child: Text('No books found.'),
            );
          } else {
            return ListView.builder(
              itemCount: bookController.books.length,
              itemBuilder: (context, index) {
                final book = bookController.books[index];
                return BookCard(
                    book: book, downloadController: downloadcontroller);
              },
            );
          }
        },
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;
  final FileDownloadController downloadController;

  const BookCard(
      {Key? key, required this.book, required this.downloadController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book.academic ?? ''),
                      const Divider(),
                      if (book.attachments!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: book.attachments!.length,
                              itemBuilder: (context, index) {
                                final attachment = book.attachments![index];
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Text(attachment.fileName ?? ''),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.download,
                                        color: Color(0xFFB97CFC) ,),
                                      onPressed: () {
                                        SharedData.getFromStorage('parent', 'object', 'uid').then((uid) {
                                          downloadController.downloadFile(
                                            uid, // Replace the argument with the uid obtained from SharedData
                                            attachment.id.toString(),
                                            attachment.fileName ?? '',
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
