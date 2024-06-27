import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanemaonline/api/subscription_api.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/providers/auth_provider.dart';
import 'package:kanemaonline/providers/packages_provider.dart';
import 'package:kanemaonline/providers/user_info_provider.dart';
import 'package:kanemaonline/screens/profile_screens/subscriptions/select_package_screen.dart';
import 'package:kanemaonline/screens/profile_screens/subscriptions/view_payperview_screen.dart';
import 'package:kanemaonline/widgets/activity_loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  var subscriptionsList = [];
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    getMySubs();
  }

  void getMySubs() async {
    isLoading = true;
    setState(() {});
    try {
      subscriptionsList = await SubscriptionsAPI.getSubscriptions(
        userid: Provider.of<AuthProvider>(context, listen: false).userid,
      );

      isLoading = false;
      setState(() {});
    } catch (err) {
      isLoading = false;
      setState(() {});
      debugPrint(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscriptions & Packages"),
      ),
      body: SingleChildScrollView(
        child: Consumer<PackagesProvider>(builder: (context, value, _) {
          if (value.isLoading) {
            return const CustomIndicatorWidget();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                _buildMySubscriptions(),
                const SizedBox(height: 25),
                _buildUpgradePackages(value.packages),
                const SizedBox(height: 35),
              ],
            ),
          );
        }),
      ),
    );
  }

  _buildPayPerView() {
    List subscriptionsLocal = List.from(subscriptionsList);
    subscriptionsLocal.removeWhere((element) => element['ppv'] == false);

    if (subscriptionsLocal.any((element) => element['ppv'] == true)) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ViewPayPerViewScreen(
                subscriptions: subscriptionsLocal,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          margin: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: darkerAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.width * 0.25,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: darkGrey.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/logo-white.png"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pay Per View",
                        style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Your one time watch subscriptions",
                        style: TextStyle(
                          color: darkGrey,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            List.generate(subscriptionsLocal.length, (index) {
                          if (subscriptionsLocal[index]['ppv'] == false) {
                            return Container();
                          }
                          return Row(
                            children: [
                              Text(
                                "${index + 1}. ",
                                style: TextStyle(color: white),
                              ),
                              Text(
                                subscriptionsLocal[index]['package_name'],
                                style: TextStyle(
                                  color: white.withOpacity(0.8),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  const CupertinoListTileChevron(),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  _buildPackageSubscription() {
    List subscriptionsLocal = List.from(subscriptionsList);
    subscriptionsLocal.removeWhere((element) => element['ppv'] == true);

    List filteredList = List.from(subscriptionsLocal);

    filteredList
        .removeWhere((element) => element['package_name'] != "KanemaSupa");

    if (filteredList.isNotEmpty) {
      subscriptionsLocal = filteredList;
    }

    if (subscriptionsList.isNotEmpty &&
        subscriptionsList.any((element) => element['ppv'] == false)) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xff242424),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: List.generate(
              subscriptionsLocal.length,
              (index) => Column(
                    children: [
                      _packageListTileUpgradable(
                        imageUrl: "",
                        duration: subscriptionsLocal[index]['duration'] ?? 30,
                        createdAt: subscriptionsLocal[index]['created_at'],
                        title: subscriptionsLocal[index]["package_name"],
                        description: "",
                        onTap: () {
                          // Navigate to the package screen
                        },
                        price: int.parse(subscriptionsLocal[index]['price']),
                      ),
                      if (subscriptionsLocal.length - 1 != index) _divider(),
                    ],
                  )),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Center(
          child: Text(
            "You don't have package subscriptions. Upgrade below.",
            style: TextStyle(
              color: white.withOpacity(0.75),
            ),
          ),
        ),
      );
    }
  }

  _buildMySubscriptions() {
    return isLoading
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Center(
              child: Text(
                "Please wait while we get your subscriptions",
                style: TextStyle(
                  color: white.withOpacity(0.75),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        : Consumer<UserInfoProvider>(
            builder: (context, value, _) {
              // Debugging: Print the user data structure
              print(value.userData);

              List subscriptions = [];
              try {
                subscriptions =
                    value.userData['message'][0]['status']['subscriptions'];
              } catch (e) {
                print('Error accessing subscriptions: $e');
              }

              // Ensure subscriptions is a List of Maps
              if (subscriptions.isNotEmpty) {
                try {
                  List filteredSubscriptions = subscriptions
                      .where((element) =>
                          element is Map &&
                          element['package_name'] == 'KanemaSupa')
                      .toList();

                  if (filteredSubscriptions.isNotEmpty) {
                    subscriptions = filteredSubscriptions;
                  }
                } catch (e) {
                  print('Error filtering subscriptions: $e');
                }
              } else {
                print('Subscriptions list is empty or not a List');
              }

              return subscriptions.isEmpty
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Subscriptions",
                          style: TextStyle(
                            color: white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildPayPerView(),
                        _buildPackageSubscription(),
                      ],
                    );
            },
          );
  }

  _buildUpgradePackages(List allPackages) {
    // Extract package names of current subscriptions
    List<dynamic> currentPackageNames =
        subscriptionsList.map((sub) => sub['package_name']).toList();

    // If the "KanemaSupa" package is among the current subscriptions, clear the allPackages list
    if (currentPackageNames.contains('KanemaSupa')) {
      allPackages = [];
    } else {
      // Remove current subscriptions from all packages
      allPackages.removeWhere(
          (package) => currentPackageNames.contains(package['name']));
    }

    if (allPackages.isEmpty) {
      return Container();
    }

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
            children: allPackages
                .asMap()
                .entries
                .map((e) => Column(
                      children: [
                        _packageListTile(
                          imageUrl: "",
                          title: e.value["name"],
                          description: e.value['description'],
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
                        if (e.key != allPackages.length - 1) _divider(),
                      ],
                    ))
                .toList(),
          ),
        )
      ],
    );
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
                ).format(price),
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

  Widget _packageListTileUpgradable({
    required String title,
    required String description,
    required int price,
    required String imageUrl,
    required Function onTap,
    required String createdAt,
    required int duration,
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
                width: MediaQuery.of(context).size.width * 0.4,
                child: Text(
                  "Exp: ${intl.DateFormat("dd MMM,yyyy").format(DateTime.parse(createdAt).add(
                    Duration(days: duration),
                  ))}",
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
                ).format(price),
                style: TextStyle(
                  color: white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Expanded(child: Container()),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SelectPackageScreen(
                    packageName: title,
                    price: price,
                    isPayperView: false,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: green, width: 1.5),
              ),
              child: Text(
                "Renew",
                style: TextStyle(
                  color: green,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
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
