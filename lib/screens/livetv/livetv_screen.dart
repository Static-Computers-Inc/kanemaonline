import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/fx/watch_bridge_functions.dart';
import 'package:kanemaonline/providers/tvs_provider.dart';
import 'package:kanemaonline/screens/livetv/all_tvs_search_screen.dart';
import 'package:kanemaonline/screens/players/mini_player_popup.dart';
import 'package:kanemaonline/widgets/hero_search_appbar.dart';
import 'package:kanemaonline/widgets/scaffold_wrapper.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class LiveTVScreen extends StatefulWidget {
  const LiveTVScreen({super.key});

  @override
  State<LiveTVScreen> createState() => _LiveTVScreenState();
}

class _LiveTVScreenState extends State<LiveTVScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      child: Scaffold(
        backgroundColor: black,
        extendBodyBehindAppBar: true,
        appBar: HeroSearchAppBar.appBar(searchOnTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => const AllTVsSearchScreen()));
        }),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<TVsProvider>(
                builder: (context, value, child) {
                  var index = 1;

                  return Container(
                    decoration: BoxDecoration(
                      color: white,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          value.tvs[index]['thumb_nail'],
                        ),
                      ),
                    ),

                    height: MediaQuery.of(context).size.height * 0.3,
                    // width: double.infinity,
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
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  transparent,
                                  black.withOpacity(0.5),
                                  black,
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    var data = value.tvs[index];
                                    WatchBridgeFunctions.watchTVBridge(
                                      id: data['_id'],
                                      watchTV: () {
                                        showCupertinoModalBottomSheet(
                                          topRadius: Radius.zero,
                                          context: context,
                                          backgroundColor: black,
                                          barrierColor: black,
                                          builder: (context) => MiniPlayerPopUp(
                                            title: data['name'],
                                            videoUrl: data['stream_key'],
                                            data: data,
                                          ),
                                        );
                                      },
                                      packages: [
                                        "Kiliye Kiliye",
                                        "KanemaSupa",
                                        data['name']
                                      ],
                                      contentName: data['name'],
                                      thumbnail: data['thumb_nail'],
                                      price: data['price'],
                                      isPublished: data['status']['publish'],
                                    );
                                  },
                                  child: SvgPicture.asset(
                                    "assets/svg/play_special.svg",
                                    // color: white,
                                    width: 70,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  "${value.tvs[index]['name']}",
                                  style: TextStyle(
                                    color: white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Consumer<TVsProvider>(
                        builder: (context, tvsProvider, child) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1 / 1,
                        ),
                        itemCount: tvsProvider.tvs.length,
                        itemBuilder: (context, index) {
                          // if (tvsProvider.tvs[index]['status']['visibility'] ==
                          //     false) {
                          //   return Container();
                          // }
                          return GestureDetector(
                            onTap: () {
                              var data = tvsProvider.tvs[index];
                              WatchBridgeFunctions.watchTVBridge(
                                id: data['_id'],
                                watchTV: () {
                                  showCupertinoModalBottomSheet(
                                    topRadius: Radius.zero,
                                    context: context,
                                    backgroundColor: black,
                                    barrierColor: black,
                                    builder: (context) => MiniPlayerPopUp(
                                      title: data['name'],
                                      videoUrl: data['stream_key'],
                                      data: data,
                                    ),
                                  );
                                },
                                packages: [
                                  "Kiliye Kiliye",
                                  "KanemaSupa",
                                  data['name']
                                ],
                                contentName: data['name'],
                                thumbnail: data['thumb_nail'],
                                price: data['price'],
                                isPublished: data['status']['publish'],
                              );
                            },
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: CachedNetworkImageProvider(
                                        tvsProvider.tvs[index]['thumb_nail'],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          black.withOpacity(1),
                                          black.withOpacity(0.7),
                                          black.withOpacity(0.0),
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tvsProvider.tvs[index]['name'],
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
                          );
                        },
                      );
                    }),
                  ),
                  Positioned(
                    left: 15,
                    top: 45,
                    child: Text(
                      "More TVs",
                      style: TextStyle(
                          color: white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
