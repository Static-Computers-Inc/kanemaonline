import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intl/intl.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/providers/packages_provider.dart';
import 'package:kanemaonline/screens/profile_screens/subscriptions/payment_gateway_screen.dart';
import 'package:provider/provider.dart';

class SelectPackageScreen extends StatefulWidget {
  final String packageName;
  final int price;
  final bool isPayperView;
  const SelectPackageScreen({
    super.key,
    required this.packageName,
    required this.price,
    required this.isPayperView,
  });

  @override
  State<SelectPackageScreen> createState() => _SelectPackageScreenState();
}

class _SelectPackageScreenState extends State<SelectPackageScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Duration",
        ),
      ),
      body: Consumer<PackagesProvider>(builder: (context, value, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                widget.packageName.trim(),
                style: TextStyle(
                  color: white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Choose your best option",
                style: TextStyle(
                  color: white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 15),
              _buildMonthListTile(),
              const SizedBox(height: 15),
              _buildButton(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMonthListTile() {
    return Column(
      children: [
        _buildTileContainer(
          onTap: () {
            selectedIndex = 0;
            setState(() {});
          },
          name: "1 Month",
          price: widget.price * 1,
          isSelected: selectedIndex == 0,
        ),
        _buildTileContainer(
          onTap: () {
            selectedIndex = 1;
            setState(() {});
          },
          name: "2 Months",
          price: widget.price * 2,
          isSelected: selectedIndex == 1,
        ),
        _buildTileContainer(
          onTap: () {
            selectedIndex = 2;
            setState(() {});
          },
          name: "3 Months",
          price: widget.price * 3,
          isSelected: selectedIndex == 2,
        ),
      ],
    );
  }

  _buildTileContainer({
    required Function onTap,
    required String name,
    required int price,
    required bool isSelected,
  }) {
    return Bounceable(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            color: const Color(0xFF242424),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: darkGrey.withOpacity(0.4),
              width: 1.2,
            )),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  NumberFormat.currency(
                    locale: 'en',
                    symbol: "MK ",
                    decimalDigits: 0,
                  ).format(price),
                  style: TextStyle(
                    color: lightGrey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Expanded(child: Container()),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: isSelected ? white : transparent,
                border: Border.all(
                  color: isSelected ? white : darkGrey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: isSelected
                  ? Center(
                      child: Icon(
                        Icons.check,
                        size: 12,
                        color: black,
                      ),
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Bounceable(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => PaymentGatewayScreen(
              totalPrice: widget.price * (selectedIndex + 1),
              packageName: widget.packageName,
              duration: 30 * (selectedIndex + 1),
              isPayPerView: widget.isPayperView,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Center(
          child: Text(
            "Subscribe",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
