// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:kanemaonline/api/watchlist_api.dart';
import 'package:kanemaonline/helpers/fx/betterlogger.dart';
import 'package:kanemaonline/main.dart';
import 'package:kanemaonline/providers/packages_provider.dart';
import 'package:kanemaonline/providers/user_info_provider.dart';
import 'package:kanemaonline/providers/watchlist_provider.dart';
import 'package:kanemaonline/widgets/not_publsihed_pop.dart';
import 'package:kanemaonline/widgets/subscribe_popup.dart';
import 'package:provider/provider.dart';

class WatchBridgeFunctions {
  static watchTVBridge({
    required String id,
    required Function watchTV,
    required String contentName,
    required String thumbnail,
    required int price,
    required List packages,
    required bool isPublished,
  }) async {
    // check if content is published

    if (!isPublished) {
      return showCupertinoModalPopup(
        context: navigatorKey.currentState!.context,
        builder: (context) => const NotPublisedPopup(),
      );
    }

    // check subscription

    bool hasSubscription = false;

    var userData = Provider.of<UserInfoProvider>(
      navigatorKey.currentState!.context,
      listen: false,
    ).userData;
    List subscriptions = userData['message'][0]['status']['subscriptions'];

    List allPackages = Provider.of<PackagesProvider>(
      navigatorKey.currentState!.context,
      listen: false,
    ).packages;

    if (subscriptions.contains(contentName)) {
      watchTV();
      await WatchListAPI().addItem(id: id);
      Provider.of<WatchListProvider>(navigatorKey.currentState!.context,
              listen: false)
          .init();
      return;
    }

    // debugPrint(subscriptions.toString());
    // hasSubscription = subscriptions.any(
    //   (element) => packages.any(
    //     (package) => element == package,
    //   ),
    // );

    if (subscriptions.isNotEmpty) {
      if (subscriptions.isNotEmpty) {
        hasSubscription = await checkSubscription(
          contentName: contentName,
          subscriptions: subscriptions,
          allPackages: allPackages,
        );
      }
    }

    if (hasSubscription) {
      watchTV();
      await WatchListAPI().addItem(id: id);
      Provider.of<WatchListProvider>(navigatorKey.currentState!.context,
              listen: false)
          .init();
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
    required String id,
    required Function watchVideo,
    required List packages,
    required String contentName,
    required String thumbnail,
    required int price,
    required bool isPublished,
  }) async {
    if (!isPublished) {
      return showCupertinoModalPopup(
        context: navigatorKey.currentState!.context,
        builder: (context) => const NotPublisedPopup(),
      );
    }

    // check subscription

    bool hasSubscription = false;

    var userData = Provider.of<UserInfoProvider>(
      navigatorKey.currentState!.context,
      listen: false,
    ).userData;
    List subscriptions = userData['message'][0]['status']['subscriptions'];

    List allPackages = Provider.of<PackagesProvider>(
      navigatorKey.currentState!.context,
      listen: false,
    ).packages;

    if (subscriptions.contains(contentName)) {
      watchVideo();
      await WatchListAPI().addItem(id: id);
      Provider.of<WatchListProvider>(navigatorKey.currentState!.context,
              listen: false)
          .init();
      return;
    }

    if (subscriptions.isNotEmpty) {
      hasSubscription = await checkSubscription(
        contentName: contentName,
        subscriptions: subscriptions,
        allPackages: allPackages,
      );
    }

    if (hasSubscription) {
      watchVideo();
      await WatchListAPI().addItem(id: id);
      Provider.of<WatchListProvider>(navigatorKey.currentState!.context,
              listen: false)
          .init();
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
    required String id,
    required Function watchLive,
    required List packages,
    required String contentName,
    required String thumbnail,
    required int price,
    required bool isPublished,
  }) async {
    // check subscription

    if (!isPublished) {
      return showCupertinoModalPopup(
        context: navigatorKey.currentState!.context,
        builder: (context) => const NotPublisedPopup(),
      );
    }

    bool hasSubscription = false;

    var userData = Provider.of<UserInfoProvider>(
      navigatorKey.currentState!.context,
      listen: false,
    ).userData;
    List subscriptionsCloud = userData['message'][0]['status']['subscriptions'];
    List subscriptions = List.from(subscriptionsCloud);

    List allPackages = Provider.of<PackagesProvider>(
      navigatorKey.currentState!.context,
      listen: false,
    ).packages;

    //check if its in payperview

    if (subscriptions.contains(contentName)) {
      watchLive();
      await WatchListAPI().addItem(id: id);
      Provider.of<WatchListProvider>(
        navigatorKey.currentState!.context,
        listen: false,
      ).init();
      return;
    }

    subscriptions.remove(contentName);

    console.log(subscriptions);

    if (subscriptions.isNotEmpty) {
      if (subscriptions.isNotEmpty) {
        hasSubscription = await checkSubscription(
          contentName: contentName,
          subscriptions: subscriptions,
          allPackages: allPackages,
        );
      }
    }

    if (hasSubscription) {
      watchLive();
      await WatchListAPI().addItem(id: id);
      Provider.of<WatchListProvider>(
        navigatorKey.currentState!.context,
        listen: false,
      ).init();
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

  static Future<bool> checkSubscription({
    required String contentName,
    required List<dynamic> subscriptions,
    required List<dynamic> allPackages,
  }) async {
    try {
      if (subscriptions.isEmpty) return false;

      for (var subscription in subscriptions) {
        var result = allPackages.firstWhere(
          (element) => element['name'] == subscription,
          orElse: () => null,
        );

        var content = result['content'] ?? [];
        var secondResult = content.firstWhere(
          (element) => element['name'] == contentName,
          orElse: () => null,
        );

        if (secondResult != null) {
          return true;
        }
      }

      return false;
    } catch (err) {
      console.log('Error in checkSubscription: $err');
      return false;
    }
  }
}
