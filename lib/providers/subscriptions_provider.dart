import 'package:flutter/cupertino.dart';

class SubscriptionsProvider with ChangeNotifier {
  List get subscriptions => _subscriptions;
  final List _subscriptions = [];

  getSubscriptions() {}
}
