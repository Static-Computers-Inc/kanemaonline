import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/providers/packages_provider.dart';
import 'package:kanemaonline/screens/profile_screens/subscriptions/select_package_screen.dart';
import 'package:kanemaonline/widgets/activity_loading_widget.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart' as intl;

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscriptions & Packages"),
      ),
      body: Consumer<PackagesProvider>(builder: (context, value, _) {
        if (value.isLoading) {
          return const CustomIndicatorWidget();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              _buildUpgradePackages(),
            ],
          ),
        );
      }),
    );
  }

  _buildUpgradePackages() {
    return Consumer<PackagesProvider>(builder: (context, value, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Upgrade Packages",
            style: TextStyle(
              color: white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xff242424),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: value.packages
                  .asMap()
                  .entries
                  .map(
                    (e) => Column(
                      children: [
                        _packageListTile(
                          imageUrl: "",
                          title: e.value["name"],
                          description: "Get access to all contents",
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => SelectPackageScreen(
                                  packageName: e.value['name'],
                                  price: e.value['price'],
                                  isPayperView: false,
                                ),
                              ),
                            );
                          },
                          price: e.value['price'],
                        ),
                        if (e.key != value.packages.length - 1) _divider(),
                      ],
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      );
    });
  }

  Widget _packageListTile({
    required String title,
    required String description,
    required int price,
    required String imageUrl,
    required Function onTap,
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                decoration: BoxDecoration(
                  color: darkGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  description,
                  style: TextStyle(
                    color: lightGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                intl.NumberFormat.currency(
                  locale: "en",
                  symbol: "MK",
                  decimalDigits: 0,
                ).format(
                  price,
                ),
                style: TextStyle(
                  color: white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Expanded(child: Container()),
          const SizedBox(width: 15),
          const CupertinoListTileChevron()
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: darkGrey.withOpacity(0.4),
      height: 1,
    );
  }
}
