import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanemaonline/api/payment_api.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/screens/profile_screens/subscriptions/subscription_cofirm_page.dart';
import 'package:kanemaonline/screens/profile_screens/subscriptions/subscription_failed_screen.dart';
import 'package:kanemaonline/widgets/bot_toasts.dart';

class SubscriptionPendingPage extends StatefulWidget {
  final String depositID;
  const SubscriptionPendingPage({
    super.key,
    required this.depositID,
  });

  @override
  State<SubscriptionPendingPage> createState() =>
      _SubscriptionPendingPageState();
}

class _SubscriptionPendingPageState extends State<SubscriptionPendingPage> {
  @override
  void initState() {
    super.initState();
    checkPaymentStatus();
  }

  void checkPaymentStatus() async {
    for (var i = 0; i < 30; i++) {
      try {
        await Future.delayed(const Duration(seconds: 2));
        final paymentStatus = await PaymentAPI.checkPaymentStatus(
          depositID: widget.depositID,
        );
        if (paymentStatus.isNotEmpty) {
          if (paymentStatus[0]['status'] == "PENDING") {
            debugPrint("Payment Status: ${paymentStatus[0]['status']}");
          } else if (paymentStatus[0]['status'] == "COMPLETED") {
            debugPrint("Payment Status: ${paymentStatus[0]['status']}");
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const SubscriptionConfirmedPage(),
              ),
            );
            return;
          } else {
            BotToasts.showToast(
              message: "Transaction Failed. Please try again.",
              isError: true,
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const SubscriptionFailed(),
              ),
            );
            return;
          }
        }
      } on Exception catch (e) {
        print("Exception in checkPaymentStatus: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checking Payment"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: CupertinoActivityIndicator(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Please wait while we checking your payment. Stay on this page.",
            style: TextStyle(
              color: white,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
