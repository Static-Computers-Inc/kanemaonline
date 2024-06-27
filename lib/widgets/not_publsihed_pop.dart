import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';

class NotPublisedPopup extends StatefulWidget {
  const NotPublisedPopup({super.key});

  @override
  State<NotPublisedPopup> createState() => _NotPublisedPopupState();
}

class _NotPublisedPopupState extends State<NotPublisedPopup> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: transparent,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              const Text(
                "Sorry, this video is not yet published",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      "Ok",
                      style:
                          TextStyle(color: white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
