import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/fx/watch_bridge_functions.dart';
import 'package:kanemaonline/providers/live_events_provider.dart';
import 'package:kanemaonline/providers/my_list_provider.dart';
import 'package:kanemaonline/screens/live_events/all_events_search_screen.dart';

import 'package:kanemaonline/screens/players/video_player.dart';
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
                isError: true,
              );
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
                              mediaInfo: value.events[0],
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

  Widget _buildHeroWidget({
    required Map<dynamic, dynamic> mediaInfo,
  }) {
    return HeroWidget(
      itemId: "",
      imageUrl: mediaInfo['thumb_nail'],
      playAction: () {
        WatchBridgeFunctions.watchLiveBridge(
          watchLive: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => VideoPlayerScreen(
                  title: mediaInfo['name'],
                  videoUrl: mediaInfo['stream_key'],
                ),
              ),
            );
          },
          packages: ["Kanema Events", "KanemaSupa", mediaInfo['name']],
          contentName: mediaInfo['name'],
          thumbnail: mediaInfo['thumb_nail'],
          price: mediaInfo['price'],
        );
      },
      myListAction: () {
        Provider.of<MyListProvider>(context, listen: false).addToMyList(
          id: mediaInfo['id'],
          name: mediaInfo['name'],
          description: mediaInfo['description'],
          thumbnail: mediaInfo['thumb_nail'],
          mediaUrl: mediaInfo['stream_key'],
          mediaType: 'event',
        );
      },
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
        TrendingListSMWidget(
            trending: trending,
            clickableAction: (data) {
              WatchBridgeFunctions.watchLiveBridge(
                watchLive: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => VideoPlayerScreen(
                        title: data['name'],
                        videoUrl: data['stream_key'],
                      ),
                    ),
                  );
                },
                packages: ["Kanema Events", "KanemaSupa", data['name']],
                contentName: data['name'],
                thumbnail: data['thumb_nail'],
                price: data['price'],
              );
            }),
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
        TrendingListSMWidget(
          trending: trending,
          clickableAction: (data) {
            WatchBridgeFunctions.watchLiveBridge(
              watchLive: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => VideoPlayerScreen(
                      title: data['name'],
                      videoUrl: data['stream_key'],
                    ),
                  ),
                );
              },
              packages: ["Kanema Events", "KanemaSupa", data['name']],
              contentName: data['name'],
              thumbnail: data['thumb_nail'],
              price: data['price'],
            );
          },
        ),
      ],
    );
  }
}
