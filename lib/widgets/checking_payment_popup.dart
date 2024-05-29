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
  final String paymentMethod;
  const CheckingPaymentPopup({
    super.key,
    required this.depositID,
    required this.packageName,
    required this.amount,
    required this.onRetry,
    required this.isPayperView,
    required this.paymentMethod,
  });

  @override
  State<CheckingPaymentPopup> createState() => _CheckingPaymentPopupState();
}

class _CheckingPaymentPopupState extends State<CheckingPaymentPopup> {
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    checkPaymentStatus();
  }

  void checkPaymentStatus() async {
    for (var i = 0; i < 120; i++) {
      if (_isDisposed) return; // Exit the loop if the widget is disposed

      try {
        await Future.delayed(const Duration(seconds: 5));
        if (_isDisposed) {
          return; // Exit the loop if the widget is disposed after delay
        }

        final paymentStatus = await PaymentAPI.checkPaymentStatus(
          depositID: widget.depositID,
        );
        if (paymentStatus.isNotEmpty) {
          if (paymentStatus[0]['status'] == "ACCEPTED" ||
              paymentStatus[0]['status'] == "PENDING") {
            debugPrint("Payment Status: ${paymentStatus[0]['status']}");
          } else if (paymentStatus[0]['status'] == "COMPLETED") {
            debugPrint("Payment Status: ${paymentStatus[0]['status']}");
            if (!_isDisposed) {
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
                  paymentMethod: widget.paymentMethod,
                ),
              );
            }
          } else {
            BotToasts.showToast(
              message: "Transaction Failed. Please try again.",
              isError: true,
            );
            if (!_isDisposed) {
              Navigator.pop(context);
              return showCupertinoModalPopup(
                context: context,
                builder: (context) => PaymentFailedPopUp(
                  packageName: widget.packageName,
                  depositID: widget.depositID,
                  amount: widget.amount,
                  paymentMethod: widget.paymentMethod,
                  failedReason: paymentStatus[0]['failure_reason'] ?? "",
                  onRetry: widget.onRetry,
                  isPayperview: widget.isPayperView,
                ),
              );
            }
          }
        }
      } on Exception catch (e) {
        print("Exception in checkPaymentStatus: ${e.toString()}");
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: transparent,
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
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
