import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';

class PaymentFailedPopUp extends StatefulWidget {
  final String packageName;
  final String depositID;
  final double amount;
  final String failedReason;
  final Function onRetry;
  final bool isPayperview;

  const PaymentFailedPopUp({
    super.key,
    required this.packageName,
    required this.depositID,
    required this.amount,
    required this.failedReason,
    required this.onRetry,
    required this.isPayperview,
  });

  @override
  State<PaymentFailedPopUp> createState() => _PaymentFailedPopUpState();
}

class _PaymentFailedPopUpState extends State<PaymentFailedPopUp> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: red,
                borderRadius: BorderRadius.circular(
                  100,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: red,
                    borderRadius: BorderRadius.circular(
                      100,
                    ),
                    border: Border.all(
                      color: white,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.clear,
                    color: white,
                    size: 35,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Payment Failed",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Transaction failed with reference number: ${widget.depositID}",
                style: const TextStyle(
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ListTile(
              title: Text(
                widget.failedReason,
                style: TextStyle(
                  color: red,
                ),
              ),
              subtitle: const Text("Reason"),
            ),
            ListTile(
              title: Row(
                children: [
                  Text(
                    widget.packageName,
                    style: TextStyle(
                      color: black,
                    ),
                  ),
                  Text(
                    widget.isPayperview ? " (Pay Per View)" : "",
                    style: TextStyle(
                      color: black,
                    ),
                  ),
                ],
              ),
              subtitle: const Text("Package Name"),
            ),
            ListTile(
              title: Text(
                NumberFormat.currency(symbol: "MWK ", decimalDigits: 0)
                    .format(widget.amount),
                style: TextStyle(
                  color: black,
                ),
              ),
              subtitle: const Text("Amount"),
            ),
            ListTile(
              title: Text(
                DateFormat("dd-MMM-yyy (hh:mm aa)").format(DateTime.now()),
                style: TextStyle(
                  color: black,
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
                          "Save",
                          style: TextStyle(
                            color: green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        widget.onRetry();
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
                            "Retry",
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.w700,
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
