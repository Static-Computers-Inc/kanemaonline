import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:kanemaonline/data/trends.dart';

import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/providers/tvs_provider.dart';
import 'package:kanemaonline/screens/players/events_player.dart';
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
        appBar: HeroSearchAppBar.appBar(searchOnTap: () {}),
        body: Consumer<TVsProvider>(builder: (context, value, child) {
          return value.isLoading
              ? Center(
                  child: CupertinoActivityIndicator(
                  color: white,
                  radius: 15,
                ))
              : value.tvs.isEmpty
                  ? RetryErrorWidget(
                      onRetry: () => {
                        Provider.of<TVsProvider>(context, listen: false).init(),
                      },
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeroWidget(imageUrl: trends[8]['thumb_nail']),

                          //
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
                                Text(
                                  "See All",
                                  style: TextStyle(
                                    color: white.withOpacity(0.5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
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
                              itemCount:
                                  trends.length >= 5 ? 5 : value.tvs.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    if (index == 0) const SizedBox(width: 15),
                                    Bounceable(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => EventsPlayer(
                                              streamKey: trends[index]
                                                  ['stream_key'],
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
                                                image:
                                                    CachedNetworkImageProvider(
                                                  trends[index]['thumb_nail'],
                                                ),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(7),
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
                                Text(
                                  "See All",
                                  style: TextStyle(
                                    color: white.withOpacity(0.5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
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
                              itemCount:
                                  value.tvs.length >= 5 ? 5 : value.tvs.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    if (index == 0) const SizedBox(width: 15),
                                    AspectRatio(
                                      aspectRatio: 1 / 1.2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(3),
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
                                            borderRadius:
                                                BorderRadius.circular(7),
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

                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Live Events",
                                  style: TextStyle(
                                    color: white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "See All",
                                  style: TextStyle(
                                    color: white.withOpacity(0.5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
        }),
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
}
