import 'package:flutter/cupertino.dart';
import 'package:kanemaonline/main.dart';
import 'package:kanemaonline/providers/user_info_provider.dart';
import 'package:kanemaonline/widgets/subscribe_popup.dart';
import 'package:provider/provider.dart';

class WatchBridgeFunctions {
  static watchTVBridge({
    required Function watchTV,
    required String contentName,
    required String thumbnail,
    required int price,
    required List packages,
  }) {
    // check subscription

    bool hasSubscription;

    var userData = Provider.of<UserInfoProvider>(
      navigatorKey.currentState!.context,
      listen: false,
    ).userData;
    List subscriptions = userData['message'][0]['status']['subscriptions'];

    debugPrint(subscriptions.toString());
    hasSubscription = subscriptions.any(
      (element) => packages.any(
        (package) => element == package,
      ),
    );

    if (hasSubscription) {
      watchTV();
    } else {
      showCupertinoModalPopup(
        context: navigatorKey.currentState!.context,
        builder: (context) => SubscribePopup(
          packageName: contentName,
          amount: price.toDouble(),
          thumbnail: thumbnail,
          packages: packages,
        ),
      );
    }
  }

  static watchVideoBridge({
    required Function watchVideo,
    required List packages,
    required String contentName,
    required String thumbnail,
    required int price,
  }) {
    // check subscription

    bool hasSubscription;

    var userData = Provider.of<UserInfoProvider>(
      navigatorKey.currentState!.context,
      listen: false,
    ).userData;
    List subscriptions = userData['message'][0]['status']['subscriptions'];
    hasSubscription = subscriptions.any(
      (element) => packages.any(
        (package) => element == package,
      ),
    );

    if (hasSubscription) {
      watchVideo();
    } else {
      showCupertinoModalPopup(
        context: navigatorKey.currentState!.context,
        builder: (context) => SubscribePopup(
          packageName: contentName,
          amount: price.toDouble(),
          thumbnail: thumbnail,
          packages: packages,
        ),
      );
    }
  }

  static watchLiveBridge({
    required Function watchLive,
    required List packages,
    required String contentName,
    required String thumbnail,
    required int price,
  }) {
    // check subscription

    bool hasSubscription;

    var userData = Provider.of<UserInfoProvider>(
      navigatorKey.currentState!.context,
      listen: false,
    ).userData;
    List subscriptions = userData['message'][0]['status']['subscriptions'];
    hasSubscription = subscriptions.any(
      (element) => packages.any(
        (package) => element == package,
      ),
    );

    if (hasSubscription) {
      watchLive();
    } else {
      showCupertinoModalPopup(
        context: navigatorKey.currentState!.context,
        builder: (context) => SubscribePopup(
          packageName: contentName,
          amount: price.toDouble(),
          thumbnail: thumbnail,
          packages: packages,
        ),
      );
    }
  }
}
