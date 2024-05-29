import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/fx/watch_bridge_functions.dart';
import 'package:kanemaonline/providers/live_events_provider.dart';
import 'package:kanemaonline/providers/my_list_provider.dart';
import 'package:kanemaonline/providers/navigation_bar_provider.dart';
import 'package:kanemaonline/providers/trending_provider.dart';
import 'package:kanemaonline/providers/tvs_provider.dart';
import 'package:kanemaonline/providers/vods_provider.dart';
import 'package:kanemaonline/screens/details_pages/live_event_details.dart';
import 'package:kanemaonline/screens/details_pages/live_tv_details.dart';
import 'package:kanemaonline/screens/details_pages/single_video_details.dart';

import 'package:kanemaonline/screens/players/live_tvs_player.dart';
import 'package:kanemaonline/screens/players/video_player.dart';
import 'package:kanemaonline/screens/search/search_all_screen.dart';
import 'package:kanemaonline/widgets/activity_loading_widget.dart';
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
        appBar: HeroSearchAppBar.appBar(
          searchOnTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const SearchAllScreen(),
              ),
            );
          },
        ),
        body: Consumer<TVsProvider>(
          builder: (context, value, child) {
            return value.isLoading ||
                    Provider.of<TrendingProvider>(context).isLoading
                ? const CustomIndicatorWidget()
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
                            Consumer<TrendingProvider>(
                              builder: (context, value, _) {
                                return value.trends.isEmpty
                                    ? Container()
                                    : _buildHeroWidget(
                                        imageUrl: value.trends[0]['thumb_nail'],
                                        mediaInfo: value.trends[0],
                                      );
                              },
                            ),
                            _buildTrending(),
                            _buildLiveTVs(),
                            _buildEvents(),
                            _buildVideos(),
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
    required String imageUrl,
    required Map<dynamic, dynamic> mediaInfo,
  }) {
    return HeroWidget(
      itemId: mediaInfo['_id'],
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
          id: mediaInfo['_id'],
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
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: value.trends.length >= 5 ? 5 : value.trends.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    if (index == 0) const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        if (value.trends[index]['category'] == 'event') {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => SingleEventDetails(
                                data: value.trends[index],
                              ),
                            ),
                          );
                        } else if (value.trends[index]['category'] ==
                            "live_tv") {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => SingleTVDetails(
                                data: value.trends[index],
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => SingleVideoDetails(
                                data: value.trends[index],
                              ),
                            ),
                          );
                        }
                      },
                      child: AspectRatio(
                        aspectRatio: 1 / 1.2,
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: darkGrey.withOpacity(0.5),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                        value.trends[index]['thumb_nail'],
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                    colors: [
                                      black.withOpacity(1),
                                      black.withOpacity(0.7),
                                      black.withOpacity(0.0),
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  )),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        value.trends[index]['name'],
                                        style: TextStyle(
                                          color: white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
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
          OrientationBuilder(builder: (context, orientation) {
            return SizedBox(
              height: orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height * 0.17
                  : MediaQuery.of(context).size.height * 0.55,
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
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => SingleTVDetails(
                                data: value.tvs[index],
                              ),
                            ),
                          );
                        },
                        child: AspectRatio(
                          aspectRatio: 1 / 1.2,
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          white, // darkGrey.withOpacity(0.5),
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
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                      colors: [
                                        black.withOpacity(1),
                                        black.withOpacity(0.7),
                                        black.withOpacity(0.0),
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    )),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          value.tvs[index]['name'],
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (index == 4) const SizedBox(width: 15),
                    ],
                  );
                },
              ),
            );
          }),
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
          OrientationBuilder(builder: (context, orientation) {
            return SizedBox(
              height: orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height * 0.17
                  : MediaQuery.of(context).size.height * 0.55,
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
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => SingleVideoDetails(
                                data: value.vods[index],
                              ),
                            ),
                          );
                        },
                        child: AspectRatio(
                          aspectRatio: 1 / 1.2,
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Stack(
                              children: [
                                Container(
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
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                      colors: [
                                        black.withOpacity(1),
                                        black.withOpacity(0.7),
                                        black.withOpacity(0.0),
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    )),
                                    child: Column(
                                      children: [
                                        Text(
                                          value.vods[index]['name'],
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (index == 4) const SizedBox(width: 15),
                    ],
                  );
                },
              ),
            );
          }),
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
          OrientationBuilder(builder: (context, orientation) {
            return SizedBox(
              height: orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height * 0.17
                  : MediaQuery.of(context).size.height * 0.55,
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
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => SingleEventDetails(
                                data: value.events[index],
                              ),
                            ),
                          );
                        },
                        child: AspectRatio(
                          aspectRatio: 1 / 1.2,
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Stack(
                              children: [
                                Container(
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
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                      colors: [
                                        black.withOpacity(1),
                                        black.withOpacity(0.7),
                                        black.withOpacity(0.0),
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    )),
                                    child: Column(
                                      children: [
                                        Text(
                                          value.events[index]['name'],
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (index == 4) const SizedBox(width: 15),
                    ],
                  );
                },
              ),
            );
          }),
        ],
      );
    });
  }
}
