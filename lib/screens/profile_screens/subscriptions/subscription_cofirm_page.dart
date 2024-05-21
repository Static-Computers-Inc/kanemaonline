import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SubscriptionConfirmedPage extends StatefulWidget {
  const SubscriptionConfirmedPage({super.key});

  @override
  State<SubscriptionConfirmedPage> createState() =>
      _SubscriptionConfirmedPageState();
}

class _SubscriptionConfirmedPageState extends State<SubscriptionConfirmedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Success"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Center(
            child: LottieBuilder.asset(
              "assets/lottie/success.json",
              repeat: false,
            ),
          ),
        ],
      ),
    );
  }
}
