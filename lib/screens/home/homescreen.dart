import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanemaonline/data/trends.dart';

import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/providers/tvs_provider.dart';
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                decoration: BoxDecoration(
                  color: black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    "assets/svg/search.svg",
                    color: white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      backgroundColor: black,
      body: Consumer<TVsProvider>(builder: (context, value, child) {
        return value.isLoading
            ? Center(
                child: CupertinoActivityIndicator(
                color: white,
                radius: 20,
              ))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.37,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            trends[8]['thumb_nail'],
                          ),
                        ),
                        color: red,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    black,
                                    transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    bottom: 20,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: red,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/svg/play_special.svg",
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Play',
                                              style: TextStyle(
                                                color: white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/svg/add.svg",
                                              color: white,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'My List',
                                              style: TextStyle(
                                                color: white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/svg/info.svg",
                                              color: white,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Info',
                                              style: TextStyle(
                                                color: white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
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
                      ),
                    ),

                    //
                    const SizedBox(height: 20),
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
                        itemCount: trends.length >= 5 ? 5 : value.tvs.length,
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
                        itemCount: value.tvs.length >= 5 ? 5 : value.tvs.length,
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
                                      borderRadius: BorderRadius.circular(7),
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
    );
  }
}
