import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intl/intl.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/providers/packages_provider.dart';
import 'package:kanemaonline/screens/profile_screens/subscriptions/select_package_screen.dart';
import 'package:kanemaonline/widgets/activity_loading_widget.dart';
import 'package:provider/provider.dart';

class SingleItemSub extends StatefulWidget {
  final String thumbNail;
  final String title;
  final List packages;
  final double price;
  const SingleItemSub({
    super.key,
    required this.thumbNail,
    required this.title,
    required this.packages,
    required this.price,
  });

  @override
  State<SingleItemSub> createState() => _SingleItemSubState();
}

class _SingleItemSubState extends State<SingleItemSub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: white,
              ),
            ),
            Text(
              "Not available in your subscription",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: white,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(13),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    widget.thumbNail,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => SelectPackageScreen(
                      packageName: widget.title,
                      price: widget.price.toInt(),
                      isPayperView: true,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: white,
                ),
                child: Center(
                  child: Text(
                    "Unlock this video | ${NumberFormat.currency(symbol: "MWK ", decimalDigits: 0).format(widget.price)}",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            _buildOtherPackages(),
          ],
        ),
      ),
    );
  }

  _buildOtherPackages() {
    // debugPrint(widget.packages.toString());

    return Consumer<PackagesProvider>(builder: (context, value, _) {
      if (value.isLoading) {
        return const CustomIndicatorWidget();
      }
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: lightGrey.withOpacity(0.4)),
        ),
        child: Column(
          children: [
            Text(
              "Other plans to access this video",
              style: TextStyle(
                color: white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: widget.packages.map(
                (e) {
                  if (e == widget.title) {
                    return Container();
                  }

                  return Expanded(
                    child: Bounceable(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SelectPackageScreen(
                              packageName: e.toString(),
                              price: value.packages.firstWhere((element) =>
                                  element['name'] == e.toString())['price'],
                              isPayperView: false,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 25,
                        ),
                        decoration: BoxDecoration(
                          color: darkerAccent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: lightGrey.withOpacity(0.25),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              e.toString(),
                              style: TextStyle(
                                color: white,
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 25),
                            Text(
                              Provider.of<PackagesProvider>(context,
                                      listen: false)
                                  .packages
                                  .firstWhere((element) =>
                                      element['name'] ==
                                      e.toString())['description']
                                  .toString(),
                              style: TextStyle(
                                  color: white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 25),
                            Text(
                              NumberFormat.currency(
                                symbol: "MWK ",
                                decimalDigits: 0,
                              ).format(
                                value.packages.firstWhere((element) =>
                                    element['name'] == e.toString())['price'],
                              ),
                              style: TextStyle(
                                  color: white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "/ month",
                              style: TextStyle(fontSize: 15, color: lightGrey),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 25),
          ],
        ),
      );
    });
  }
}
