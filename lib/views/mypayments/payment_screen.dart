import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../model/child_model.dart';
import '../../theme/app_colors.dart';
import '../mychildren/payments/details_payment_child.dart';

class PaymentScreen extends StatelessWidget {
  final Mychildreen student;
  final String schoolCode;
  final int parentID;
  final int childID;
  final double amount;
  final List<int> lineIDs;

  const PaymentScreen({
    Key? key,
    required this.schoolCode,
    required this.parentID,
    required this.childID,
    required this.amount,
    required this.lineIDs,
    required this.student,
  }) : super(key: key);

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
        title: const Text(
          'Payment',
          style: TextStyle(
            color: CupertinoColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                        padding:const  EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                 Text(
                                  'Pay with Credit Card',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Icon(
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
                    side: BorderSide(color: Colors.transparent),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
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
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children:  [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Pay with Debit Card',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Icon(
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
    List<String> encodedLines = lineIDs.map((item) => 'lines[]=$item').toList();
    String lines = encodedLines.join('&');

    String url =
        'https://payment.tsdoha.com/session?school_code=$schoolCode&parent_id=$parentID&child_id=$childID&total_amount=$amount&$lines';

    String encodedUrl = Uri.encodeFull(url);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: encodedUrl,
          successCallback: () => showPaymentResultDialog(context, true),
          errorCallback: () => showPaymentResultDialog(context, false),
        ),
      ),
    );
  }

  void openDebitBrowser(BuildContext context) {
    List<String> encodedLines = lineIDs.map((item) => 'lines[]=$item').toList();
    String lines = encodedLines.join('&');
    final double amountdebit = amount * 100;
    final int amountdeb = amountdebit.toInt();
    String url =
        'https://payment.tsdoha.com/sts/checkout?school_code=$schoolCode&parent_id=$parentID&child_id=$childID&total_amount=$amountdeb&$lines';
    print(url);
    String encodedUrl = Uri.encodeFull(url);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: encodedUrl,
          successCallback: () => showPaymentResultDialog(context, true),
          errorCallback: () => showPaymentResultDialog(context, false),
        ),
      ),
    );
  }

  void showPaymentResultDialog(BuildContext context, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isSuccess ? 'Payment Successful' : 'Payment Failed'),
          content: Text(isSuccess
              ? 'Your payment was successful.'
              : 'Payment failed. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Get.to(() => TotalImpaidChild(
                  student: student,
                ));
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;
  final VoidCallback successCallback;
  final VoidCallback errorCallback;

  const WebViewScreen({
    Key? key,
    required this.url,
    required this.successCallback,
    required this.errorCallback,
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
        title: const Text(
          'Credit',
          style: TextStyle(
            color: CupertinoColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.contains('payment/success')) {
                widget.successCallback();
                return NavigationDecision.prevent;
              } else if (request.url.contains('payment/error')) {
                widget.errorCallback();
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
              child: CircularProgressIndicator(color: primarycolor,),
            ),
        ],
      ),
    );
  }
}

