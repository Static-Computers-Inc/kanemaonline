import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/fx/providers_init.dart';
import 'package:kanemaonline/screens/generics/receipt_screenshot.dart';
import 'package:lottie/lottie.dart';
import 'package:transparent_route/transparent_route.dart';

class PaymentSuccessPopup extends StatefulWidget {
  final String packageName;
  final String depositID;
  final double amount;
  final bool isPayPerView;
  final String paymentMethod;
  const PaymentSuccessPopup({
    super.key,
    required this.packageName,
    required this.depositID,
    required this.amount,
    required this.isPayPerView,
    required this.paymentMethod,
  });

  @override
  State<PaymentSuccessPopup> createState() => _PaymentSuccessPopupState();
}

class _PaymentSuccessPopupState extends State<PaymentSuccessPopup> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Center(
              child: LottieBuilder.asset(
                "assets/lottie/success.json",
                repeat: false,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Payment Successful",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Transaction completed with reference number: ${widget.depositID}",
                style: const TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Text(
                    widget.packageName,
                    style: TextStyle(
                      color: black,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    widget.isPayPerView ? " (Pay Per View)" : "",
                    style: TextStyle(
                      color: black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              subtitle: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Package Name"),
                ],
              ),
            ),
            ListTile(
              title: Text(
                "${NumberFormat.currency(symbol: "MWK ", decimalDigits: 0).format(widget.amount)} (PAID)",
                style: TextStyle(
                  color: green,
                  fontSize: 14,
                ),
              ),
              subtitle: const Text("Amount"),
            ),
            ListTile(
              title: Text(
                widget.paymentMethod,
                style: TextStyle(color: black, fontSize: 14),
              ),
              subtitle: const Text("Payment Method"),
            ),
            ListTile(
              title: Text(
                DateFormat("dd-MMM-yyy (hh:mm aa)").format(DateTime.now()),
                style: TextStyle(
                  color: black,
                  fontSize: 14,
                ),
              ),
              subtitle: const Text("Date"),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        pushScreen(
                          context,
                          ReceiptScreenshot(
                              ref: widget.depositID,
                              packageName:
                                  "${widget.packageName} ${widget.isPayPerView ? " (Pay Per View)" : ""}",
                              paymentMethod: widget.paymentMethod,
                              amount:
                                  "${NumberFormat.currency(symbol: "MWK ", decimalDigits: 0).format(widget.amount)} (PAID)",
                              date: DateFormat("dd-MMM-yyy (hh:mm aa)")
                                  .format(DateTime.now())),
                          isTransparent: true,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: green,
                            width: 3,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Save Receipt",
                            style: TextStyle(
                              color: green,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ProvidersInit.updateAfterPayment(context: context);
                        Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: green,
                        ),
                        child: Center(
                          child: Text(
                            "Done",
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ],
        ),
      ),
    );
  }
}
