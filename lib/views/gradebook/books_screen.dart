import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/constant/constant.dart';
import 'package:tsdoha/controller/dowload_file_controller.dart';
import 'package:tsdoha/controller/mychildren_controller/mychildren_controller.dart';
import 'package:tsdoha/routes/routes.dart';
import 'package:tsdoha/theme/app_colors.dart';
import 'widget/book_card.dart';

class BookListScreen extends StatefulWidget {
  final int? studentId;

  const BookListScreen({Key? key, this.studentId}) : super(key: key);

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchBooksStudents(widget.studentId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookController = Get.find<ChildrenController>();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: CupertinoColors.white),
            onPressed: () {
              Get.back();
            },
          ),
          backgroundColor: primarycolor,
          title: Text(
            'gradebook'.tr,
            style: const TextStyle(
                color: CupertinoColors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
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
        body: SafeArea(
          child: Obx(() => bookController.isLoading.isTrue
              ? Center(
                  child: CircularProgressBar(
                    color: primarycolor,
                  ),
                )
              : bookController.books.isNotEmpty
                  ? ListView.builder(
                      itemCount: bookController.books.length,
                      itemBuilder: (context, index) {
                        final book = bookController.books[index];
                        return BookCard(
                          book: book,
                          downloadController: downloadcontroller,
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/imgs/notfound.png'),
                          Text('nogradebooks'.tr),
                        ],
                      ),
                    )
          ),
        ));
  }
}
