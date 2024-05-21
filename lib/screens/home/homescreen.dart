import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:kanemaonline/data/trends.dart';

import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/fx/watch_bridge_functions.dart';
import 'package:kanemaonline/providers/live_events_provider.dart';
import 'package:kanemaonline/providers/my_list_provider.dart';
import 'package:kanemaonline/providers/navigation_bar_provider.dart';
import 'package:kanemaonline/providers/trending_provider.dart';
import 'package:kanemaonline/providers/tvs_provider.dart';
import 'package:kanemaonline/providers/vods_provider.dart';
import 'package:kanemaonline/screens/players/events_player.dart';
import 'package:kanemaonline/screens/players/live_tvs_player.dart';
import 'package:kanemaonline/screens/players/video_player.dart';
import 'package:kanemaonline/screens/search/search_all_screen.dart';
import 'package:kanemaonline/widgets/error_widget.dart';
import 'package:kanemaonline/widgets/hero_search_appbar.dart';
import 'package:kanemaonline/widgets/hero_widget.dart';
import 'package:kanemaonline/widgets/scaffold_wrapper.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var tvs = [];
  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: HeroSearchAppBar.appBar(searchOnTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const SearchAllScreen(),
            ),
          );
        }),
        body: Consumer<TVsProvider>(
          builder: (context, value, child) {
            return value.isLoading
                ? Center(
                    child: CupertinoActivityIndicator(
                      color: white,
                      radius: 15,
                    ),
                  )
                : value.tvs.isEmpty
                    ? RetryErrorWidget(
                        onRetry: () => {
                          Provider.of<TVsProvider>(context, listen: false)
                              .init(),
                        },
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeroWidget(
                              imageUrl: trends[0]['thumb_nail'],
                              mediaInfo: trends[0],
                            ),
                            _buildTrending(),
                            _buildLiveTVs(),
                            _buildVideos(),
                            _buildEvents(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
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
    required String imageUrl,
    required Map<dynamic, dynamic> mediaInfo,
  }) {
    return HeroWidget(
      itemId: mediaInfo['id'],
      imageUrl: imageUrl,
      playAction: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => VideoPlayerScreen(
              videoUrl: mediaInfo['stream_key'],
              title: mediaInfo['name'],
            ),
          ),
        );
      },
      myListAction: () {
        Provider.of<MyListProvider>(context, listen: false).addToMyList(
          id: mediaInfo['id'],
          name: mediaInfo['name'],
          description: mediaInfo['description'],
          thumbnail: mediaInfo['thumb_nail'],
          mediaUrl: mediaInfo['stream_key'],
          mediaType: 'video',
        );
      },
      infoAction: () {},
    );
  }

  Widget _buildTrending() {
    return Consumer<TrendingProvider>(builder: (context, value, _) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trending",
                  style: TextStyle(
                    color: white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // TODO: ADD THIS BACK
                // Text(
                //   "See All",
                //   style: TextStyle(
                //     color: white.withOpacity(0.5),
                //     fontSize: 14,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: trends.length >= 5 ? 5 : value.trends.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    if (index == 0) const SizedBox(width: 15),
                    Bounceable(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => LiveTvsPlayerScreen(
                              streamKey: trends[index]['stream_key'],
                              name: trends[index]['name'],
                            ),
                          ),
                        );
                      },
                      child: AspectRatio(
                        aspectRatio: 1 / 1.2,
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            decoration: BoxDecoration(
                              color: darkGrey.withOpacity(0.5),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                  trends[index]['thumb_nail'],
                                ),
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (index == 4) const SizedBox(width: 15),
                  ],
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildLiveTVs() {
    return Consumer<TVsProvider>(builder: (context, value, _) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Live TVs",
                  style: TextStyle(
                    color: white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<NavigationBarProvider>(
                      context,
                      listen: false,
                    ).changeIndex(1);
                  },
                  child: Text(
                    "See All",
                    style: TextStyle(
                      color: white.withOpacity(0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: value.tvs.length >= 5 ? 5 : value.tvs.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    if (index == 0) const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        WatchBridgeFunctions.watchTVBridge(
                          watchTV: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => LiveTvsPlayerScreen(
                                  name: "${value.tvs[index]['name']}",
                                  streamKey: value.tvs[index]['stream_key'],
                                ),
                              ),
                            );
                          },
                          contentName: value.tvs[index]['name'],
                          thumbnail: value.tvs[index]['thumb_nail'],
                          price: value.tvs[index]['price'],
                          packages: [
                            "KanemaSupa",
                            "Kiliye Kiliye",
                            value.tvs[index]['name']
                          ],
                        );
                      },
                      child: AspectRatio(
                        aspectRatio: 1 / 1.2,
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            decoration: BoxDecoration(
                              color: white, // darkGrey.withOpacity(0.5),
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: CachedNetworkImageProvider(
                                  value.tvs[index]['thumb_nail'],
                                ),
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (index == 4) const SizedBox(width: 15),
                  ],
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildVideos() {
    return Consumer<VODsProvider>(builder: (context, value, _) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Videos",
                  style: TextStyle(
                    color: white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<NavigationBarProvider>(
                      context,
                      listen: false,
                    ).changeIndex(3);
                  },
                  child: Text(
                    "See All",
                    style: TextStyle(
                      color: white.withOpacity(0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: value.vods.length >= 5 ? 5 : value.vods.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    if (index == 0) const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        WatchBridgeFunctions.watchTVBridge(
                          watchTV: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => LiveTvsPlayerScreen(
                                  name: "${value.vods[index]['name']}",
                                  streamKey: value.vods[index]['stream_key'],
                                ),
                              ),
                            );
                          },
                          contentName: value.vods[index]['name'],
                          thumbnail: value.vods[index]['thumb_nail'],
                          price: value.vods[index]['price'],
                          packages: [
                            "KanemaSupa",
                            "KanemaFlex",
                            value.vods[index]['name']
                          ],
                        );
                      },
                      child: AspectRatio(
                        aspectRatio: 1 / 1.2,
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            decoration: BoxDecoration(
                              color: white, // darkGrey.withOpacity(0.5),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                  value.vods[index]['thumb_nail'],
                                ),
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (index == 4) const SizedBox(width: 15),
                  ],
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildEvents() {
    return Consumer<LiveEventsProvider>(builder: (context, value, _) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Events",
                  style: TextStyle(
                    color: white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<NavigationBarProvider>(
                      context,
                      listen: false,
                    ).changeIndex(2);
                  },
                  child: Text(
                    "See All",
                    style: TextStyle(
                      color: white.withOpacity(0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: value.events.length >= 5 ? 5 : value.events.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    if (index == 0) const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        WatchBridgeFunctions.watchTVBridge(
                          watchTV: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => LiveTvsPlayerScreen(
                                  name: "${value.events[index]['name']}",
                                  streamKey: value.events[index]['stream_key'],
                                ),
                              ),
                            );
                          },
                          contentName: value.events[index]['name'],
                          thumbnail: value.events[index]['thumb_nail'],
                          price: value.events[index]['price'],
                          packages: [
                            "KanemaSupa",
                            "Kanema Events",
                            value.events[index]['name']
                          ],
                        );
                      },
                      child: AspectRatio(
                        aspectRatio: 1 / 1.2,
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            decoration: BoxDecoration(
                              color: white, // darkGrey.withOpacity(0.5),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                  value.events[index]['thumb_nail'],
                                ),
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (index == 4) const SizedBox(width: 15),
                  ],
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
