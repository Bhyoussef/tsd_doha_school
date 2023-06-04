import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../controller/dowload_file_controller.dart';
import '../../controller/mychildren_controller/mychildren_controller.dart';
import '../../theme/app_colors.dart';
import 'widget/book_card.dart';

class BookListScreen extends StatefulWidget {
  final int? studentId;

  const BookListScreen({Key? key,  this.studentId}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const  Icon(Icons.arrow_back_ios,color: CupertinoColors.white),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: primarycolor,
        title:    Text('gradebook'.tr,style: const  TextStyle(
            color: CupertinoColors.white,fontWeight: FontWeight.bold
        ),),
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
      body: SafeArea(
        child: Obx(
              () {
            final bookController = Get.find<ChildrenController>();

            if (bookController.isLoading.value) {
              return  Center(
                child: CircularProgressBar(color: primarycolor,),
              );
            } else if (bookController.books.isEmpty) {
              return  Center(
                child: Column(
                  children: [
                    Image.asset('assets/imgs/notfound.png'),
                    const Text('nogradebooks.tr'),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: bookController.books.length,
                itemBuilder: (context, index) {
                  final book = bookController.books[index];
                  return BookCard(
                    book: book,
                    downloadController: downloadcontroller,
                  );
                },
              );
            }
          },
        ),
      )

    );
  }
}


