import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tsdoha/views/mypayments/succes_payment.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../constant/constant.dart';
import '../../model/child_model.dart';
import '../../theme/app_colors.dart';
import '../home/home_screen.dart';
import 'failed_payment.dart';

class PaymentScreen extends StatelessWidget {
  final Mychildreen? student;
  final String? schoolCode;
  final int? parentID;
  final int? childID;
  final double? amount;
  final List<int>? lineIDs;

  const PaymentScreen({
    Key? key,
     this.schoolCode,
     this.parentID,
     this.childID,
     this.amount,
     this.lineIDs,
     this.student,
  }) : super(key: key);

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
        elevation: 0,
        backgroundColor: primarycolor,
        title:  Text(
          'mypayments'.tr,
          style:const TextStyle(
            color: CupertinoColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                Get.to(()=>HomeScreen());
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  openCreditBrowser(context);
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.transparent),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        bottom: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.deepPurpleAccent,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                             Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  [
                                Text(
                                  'paywithcredit'.tr,
                                  style:const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Icon(
                                  Icons.credit_card,
                                  size: 40,
                                  color: Colors.deepPurpleAccent,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Image.asset(
                              'assets/imgs/master-visa.png',
                              width: 100,
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  openDebitBrowser(context);
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.transparent),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        bottom: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.deepPurpleAccent,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                             Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  [
                                Text(
                                  'paywithdebit'.tr,
                                  style:const TextStyle(fontWeight: FontWeight.bold),
                                ),
                               const  Icon(
                                  Icons.credit_card,
                                  size: 40,
                                  color: Colors.deepPurpleAccent,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Image.asset(
                              'assets/imgs/naps.png',
                              width: 100,
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openCreditBrowser(BuildContext context) {
    List<String> encodedLines = lineIDs!.map((item) => 'lines[]=$item').toList();
    String lines = encodedLines.join('&');

    String url =
        'https://payment.tsdoha.com/session?school_code=$schoolCode&parent_id=$parentID&child_id=$childID&total_amount=$amount&$lines';

    String encodedUrl = Uri.encodeFull(url);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: encodedUrl,
          successCallback: () => SuccsesPayament(amount :amount),
          errorCallback: () => const FailedPayment(),
        ),
      ),
    );
  }

  void openDebitBrowser(BuildContext context) {
    List<String> encodedLines = lineIDs!.map((item) => 'lines[]=$item').toList();
    String lines = encodedLines.join('&');
    final double amountdebit = amount! * 100;
    final int amountdeb = amountdebit.toInt();
    String url =
        'https://payment.tsdoha.com/sts/checkout?school_code=$schoolCode&parent_id=$parentID&child_id=$childID&total_amount=$amountdeb&$lines';
    if (kDebugMode) {
      print(url);
    }
    String encodedUrl = Uri.encodeFull(url);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: encodedUrl,
          successCallback: () => const SuccsesPayament(),
          errorCallback: () => const  FailedPayment(),
        ),
      ),
    );
  }


}

class WebViewScreen extends StatefulWidget {
  final String? url;
  final VoidCallback? successCallback;
  final VoidCallback? errorCallback;

  const WebViewScreen({
    Key? key,
     this.url,
     this.successCallback,
     this.errorCallback,
  }) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: CupertinoColors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: primarycolor,
        title:  Text(
          'payment'.tr,
          style: const TextStyle(
            color: CupertinoColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [  Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: (){
              Get.to(()=>HomeScreen());
            },
            child: Image.asset(
              'assets/imgs/tsdIcon.png',
              width: 40,
              height: 40,
            ),
          ),
        ),],
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.contains('payment/success')) {
                widget!.successCallback!();
                return NavigationDecision.prevent;
              } else if (request.url.contains('payment/error')) {
                widget!.errorCallback!();
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              setState(() {
                _isLoading = true;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                _isLoading = false;
              });
            },
          ),
          if (_isLoading)
             Center(
              child: CircularProgressBar(color: primarycolor,),
            ),
        ],
      ),
    );
  }
}
