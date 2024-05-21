import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/screens/payments/single_item_sub.dart';

class SubscribePopup extends StatefulWidget {
  final String packageName;
  final double amount;
  final String thumbnail;
  final List packages;
  const SubscribePopup({
    super.key,
    required this.packageName,
    required this.amount,
    required this.thumbnail,
    required this.packages,
  });

  @override
  State<SubscribePopup> createState() => _SubscribePopupState();
}

class _SubscribePopupState extends State<SubscribePopup> {
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
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.cancel_outlined,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "You don't have an active subscription to view ${widget.packageName}.",
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Unlock By Subscribing",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => SingleItemSub(
                        thumbNail: widget.thumbnail,
                        title: widget.packageName,
                        packages: widget.packages,
                        price: widget.amount,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      "Subscribe",
                      style: TextStyle(
                        color: white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
