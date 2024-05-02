import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/providers/live_events_provider.dart';
import 'package:kanemaonline/screens/live_events/all_events_search_screen.dart';
import 'package:kanemaonline/widgets/bot_toasts.dart';
import 'package:kanemaonline/widgets/error_widget.dart';
import 'package:kanemaonline/widgets/hero_search_appbar.dart';
import 'package:kanemaonline/widgets/hero_widget.dart';
import 'package:kanemaonline/widgets/scaffold_wrapper.dart';
import 'package:kanemaonline/widgets/trending_list_sm_widget.dart';
import 'package:provider/provider.dart';

class LiveEventsScreen extends StatefulWidget {
  const LiveEventsScreen({super.key});

  @override
  State<LiveEventsScreen> createState() => _LiveEventsScreenState();
}

class _LiveEventsScreenState extends State<LiveEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: HeroSearchAppBar.appBar(
          searchOnTap: () {
            if (Provider.of<LiveEventsProvider>(context, listen: false)
                .events
                .isEmpty) {
              BotToasts.showToast(
                  message: "Please check your internet connection.",
                  isError: true);
              return;
            }
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const AllEventsSearchScreen(),
              ),
            );
          },
        ),
        body: Consumer<LiveEventsProvider>(
          builder: (context, value, child) {
            return value.isLoading
                ? Center(
                    child: CupertinoActivityIndicator(
                      color: white,
                      radius: 14,
                    ),
                  )
                : value.events.isEmpty
                    ? RetryErrorWidget(
                        onRetry: () {
                          Provider.of<LiveEventsProvider>(
                            context,
                            listen: false,
                          ).init();
                        },
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildHeroWidget(
                              imageUrl: value.events[0]['thumb_nail'],
                            ),
                            _buildTrendingWidget(
                              trending: value.events.getRange(0, 5).toList(),
                            ),
                            _buildEventsWidget(
                              trending: value.events.getRange(5, 10).toList(),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            )
                          ],
                        ),
                      );
          },
        ),
      ),
    );
  }

  Widget _buildHeroWidget({required String imageUrl}) {
    return HeroWidget(
      imageUrl: imageUrl,
      playAction: () {},
      myListAction: () {},
      infoAction: () {},
    );
  }

  Widget _buildTrendingWidget({required List trending}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Text(
            "Trending Events",
            style: TextStyle(
              color: white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TrendingListSMWidget(trending: trending, clickableAction: (data) {}),
      ],
    );
  }

  Widget _buildEventsWidget({required List trending}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "All Events",
                style: TextStyle(
                  color: white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const AllEventsSearchScreen(),
                    ),
                  );
                },
                child: Text(
                  "See All",
                  style: TextStyle(
                    color: white.withOpacity(0.6),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        TrendingListSMWidget(trending: trending, clickableAction: (data) {}),
      ],
    );
  }
}
