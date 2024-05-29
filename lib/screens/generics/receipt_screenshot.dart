import 'dart:io';

import 'package:blurrycontainer/blurrycontainer.dart';

import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/widgets/bot_toasts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class ReceiptScreenshot extends StatefulWidget {
  final String packageName;
  final String paymentMethod;
  final String amount;
  final String date;
  final String ref;

  const ReceiptScreenshot({
    super.key,
    required this.packageName,
    required this.paymentMethod,
    required this.amount,
    required this.date,
    required this.ref,
  });

  @override
  State<ReceiptScreenshot> createState() => _ReceiptScreenshotState();
}

class _ReceiptScreenshotState extends State<ReceiptScreenshot> {
  ScreenshotController screenshotController = ScreenshotController();

  void capture() async {
    BotToasts.showToast(message: "Downloading Receipt", isError: false);
    await screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);

        /// Share Plugin
        await Share.shareFiles(
          [imagePath.path],
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlurryContainer(
      color: black.withOpacity(0.5),
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.zero,
      child: Scaffold(
          backgroundColor: transparent,
          appBar: AppBar(
            backgroundColor: black.withOpacity(0.6),
            actions: [
              GestureDetector(
                  onTap: () => capture(),
                  child: Icon(Icons.download, color: white)),
              const SizedBox(width: 15),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Screenshot(
                  controller: screenshotController,
                  child: AspectRatio(
                    aspectRatio: 0.5 / 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: white,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child:
                                  Image.asset("assets/images/logo-color.png")),
                          const SizedBox(height: 30),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                                color: lightGrey.withOpacity(0.6)),
                            child: const Center(
                              child: Text(
                                "Transaction Receipt",
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildTile(
                                  title: "Ref Number",
                                  subtitle: widget.ref,
                                ),
                                _buildDivider(),
                                _buildTile(
                                  title: "Package Name",
                                  subtitle: widget.packageName,
                                ),
                                _buildDivider(),
                                _buildTile(
                                  title: "Amount",
                                  subtitle: widget.amount,
                                ),
                                _buildDivider(),
                                _buildTile(
                                  title: "Payment Method",
                                  subtitle: widget.paymentMethod,
                                ),
                                _buildDivider(),
                                _buildTile(
                                  title: "Date",
                                  subtitle: widget.date,
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  "Thank you, for using Kanema Online"
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: darkGrey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: darkGrey.withOpacity(0.4),
            style: BorderStyle.solid,
            width: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildTile({required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: black,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          // const Spacer(),
          Text(
            subtitle,
            style: TextStyle(
              color: darkAccent,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
