import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';

class ViewPayPerViewScreen extends StatefulWidget {
  final List subscriptions;
  const ViewPayPerViewScreen({super.key, required this.subscriptions});

  @override
  State<ViewPayPerViewScreen> createState() => _ViewPayPerViewScreenState();
}

class _ViewPayPerViewScreenState extends State<ViewPayPerViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pay Per View"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 25),
              _buildSubscriptionList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionList() {
    List subscriptions = widget.subscriptions;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xff242424),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: List.generate(subscriptions.length, (index) {
            return Column(
              children: [
                InkWell(
                  onTap: () => {},
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: darkGrey,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                  subscriptions[index]['thumb_nail'],
                                ),
                              ),
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
                            subscriptions[index]['package_name'],
                            style: TextStyle(
                              color: white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Wrap(
                            children: [
                              Text(
                                "Expires on",
                                style: TextStyle(
                                  color: white.withOpacity(0.75),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                DateFormat("MMM dd, yyy").format(
                                  DateTime.parse(
                                          subscriptions[index]['created_at'])
                                      .add(
                                    Duration(
                                      days: subscriptions[index]['duration'],
                                    ),
                                  ),
                                ),
                                style: TextStyle(
                                  color: white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Expanded(child: Container()),
                      const SizedBox(width: 15),
                      // const CupertinoListTileChevron()
                    ],
                  ),
                ),
                if (index != subscriptions.length - 1) _divider(),
              ],
            );
          }),
        ));
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: darkGrey.withOpacity(0.4),
      height: 1,
    );
  }
}
