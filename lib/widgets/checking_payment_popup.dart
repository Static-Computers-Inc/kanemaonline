import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanemaonline/api/payment_api.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/fx/providers_init.dart';
import 'package:kanemaonline/widgets/bot_toasts.dart';
import 'package:kanemaonline/widgets/payment_failed_popup.dart';
import 'package:kanemaonline/widgets/payment_success_popup.dart';

class CheckingPaymentPopup extends StatefulWidget {
  final String depositID;
  final String packageName;
  final double amount;
  final Function onRetry;
  final bool isPayperView;
  const CheckingPaymentPopup({
    super.key,
    required this.depositID,
    required this.packageName,
    required this.amount,
    required this.onRetry,
    required this.isPayperView,
  });

  @override
  State<CheckingPaymentPopup> createState() => _CheckingPaymentPopupState();
}

class _CheckingPaymentPopupState extends State<CheckingPaymentPopup> {
  @override
  void initState() {
    super.initState();
    checkPaymentStatus();
  }

  void checkPaymentStatus() async {
    for (var i = 0; i < 120; i++) {
      try {
        await Future.delayed(const Duration(seconds: 5));
        final paymentStatus = await PaymentAPI.checkPaymentStatus(
          depositID: widget.depositID,
        );
        if (paymentStatus.isNotEmpty) {
          if (paymentStatus[0]['status'] == "ACCEPTED") {
            debugPrint("Payment Status: ${paymentStatus[0]['status']}");
          } else if (paymentStatus[0]['status'] == "COMPLETED") {
            debugPrint("Payment Status: ${paymentStatus[0]['status']}");
            Navigator.pop(context);
            ProvidersInit.updateAfterPayment(context: context);
            return showCupertinoModalPopup(
              context: context,
              barrierDismissible: false,
              builder: (context) => PaymentSuccessPopup(
                packageName: widget.packageName,
                depositID: widget.depositID,
                amount: widget.amount,
                isPayPerView: widget.isPayperView,
              ),
            );
          } else {
            BotToasts.showToast(
              message: "Transaction Failed. Please try again.",
              isError: true,
            );
            Navigator.pop(context);
            return showCupertinoModalPopup(
              context: context,
              builder: (context) => PaymentFailedPopUp(
                packageName: widget.packageName,
                depositID: widget.depositID,
                amount: widget.amount,
                failedReason: paymentStatus[0]['failure_reason'],
                onRetry: widget.onRetry,
                isPayperview: widget.isPayperView,
              ),
            );
          }
        }
      } on Exception catch (e) {
        print("Exception in checkPaymentStatus: ${e.toString()}");
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: transparent,
      child: Container(
        decoration: BoxDecoration(
          color: white,
        ),
        // height: MediaQuery.of(context).size.height * 0.45,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 45),
            const CupertinoActivityIndicator(
              radius: 20,
            ),
            const SizedBox(height: 45),
            const Text(
              "Payment Processing",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            const Text(
              "Hold on, we are processing your payment. Authorize the payment on the phone number provided.",
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            )
          ],
        ),
      ),
    );
  }
}
