import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tunisian_school_doha/model/child_model.dart';
import 'package:tunisian_school_doha/views/mychildren/children_details_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatelessWidget {
  final Mychildreen student;
  final String schoolCode;
  final int parentID;
  final int childID;
  final double amount;
  final List<int> lineIDs;

  const PaymentScreen({
    super.key,
    required this.schoolCode,
    required this.parentID,
    required this.childID,
    required this.amount,
    required this.lineIDs,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFFB97CFC),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Payment',
          style: TextStyle(color: Color(0xFF7590d6)),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                openCreditBrowser(context);
              },
              child: Image.asset(
                'assets/imgs/master-visa.png',
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                openDebitBrowser(context);
              },
              child: Image.asset(
                'assets/imgs/naps.png',
                width: 150,
                height: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openCreditBrowser(BuildContext context) {
    String lines = '';
    lineIDs.forEach((item) {
      lines = lines + '&lines[]=' + item.toString();
    });

    String url =
        'https://payment.tsdoha.com/session?school_code=$schoolCode&parent_id=$parentID&child_id=$childID&total_amount=$amount$lines';

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFFB97CFC),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
                backgroundColor: Colors.white,
                title: const Text(
                  'Credit',
                  style: TextStyle(color: Color(0xFF7590d6)),
                ),
              ),
              body:  WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.contains('payment/success')) {
                showPaymentResultDialog(context, true);
                return NavigationDecision.prevent;
              } else if (request.url.contains('payment/error')) {
                showPaymentResultDialog(context, false);
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
          )
        ));
  }

  void openDebitBrowser(BuildContext context) {
    String lines = '';
    lineIDs.forEach((item) {
      lines = lines + '&lines[]=' + item.toString();
    });

    String url =
        'https://payment.tsdoha.com/sts/checkout?school_code=$schoolCode&parent_id=$parentID&child_id=$childID&total_amount=${amount}$lines';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xFFB97CFC),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            backgroundColor: Colors.white,
            title: const Text(
              'Debit',
              style: TextStyle(color: Color(0xFF7590d6)),
            ),
          ),
          body:  WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.contains('payment/success')) {
                showPaymentResultDialog(context, true);
                return NavigationDecision.prevent;
              } else if (request.url.contains('payment/error')) {
                showPaymentResultDialog(context, false);
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
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
                Get.to(() => DetailScreen(student: student));
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
