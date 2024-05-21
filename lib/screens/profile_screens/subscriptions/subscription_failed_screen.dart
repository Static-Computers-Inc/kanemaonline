import 'package:flutter/material.dart';

class SubscriptionFailed extends StatefulWidget {
  const SubscriptionFailed({super.key});

  @override
  State<SubscriptionFailed> createState() => _SubscriptionFailedState();
}

class _SubscriptionFailedState extends State<SubscriptionFailed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscription Failed"),
      ),
    );
  }
}
