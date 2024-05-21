import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';

class PayPerViewScreen extends StatefulWidget {
  const PayPerViewScreen({super.key});

  @override
  State<PayPerViewScreen> createState() => _PayPerViewScreenState();
}

class _PayPerViewScreenState extends State<PayPerViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: white,
              ),
              child: const Text("Pay Per View"),
            )
          ],
        ));
  }
}
