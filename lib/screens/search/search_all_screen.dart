import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/fx/watch_bridge_functions.dart';
import 'package:kanemaonline/providers/live_events_provider.dart';
import 'package:kanemaonline/providers/tvs_provider.dart';
import 'package:kanemaonline/providers/vods_provider.dart';
import 'package:kanemaonline/screens/players/mini_player_popup.dart';
import 'package:kanemaonline/widgets/all_media_search_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class SearchAllScreen extends StatefulWidget {
  const SearchAllScreen({super.key});

  @override
  State<SearchAllScreen> createState() => _SearchAllScreenState();
}

class _SearchAllScreenState extends State<SearchAllScreen> {
  TextEditingController searchController = TextEditingController();
  late List allContent;
  List results = [];

  searchListener() {
    if (searchController.text.isEmpty) {
      setState(() {
        results = allContent;
      });
    } else {
      setState(() {
        results = allContent
            .where((element) => element['name']
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
    searchController.addListener(searchListener);
  }

  init() {
    List allTVs = Provider.of<TVsProvider>(context, listen: false)
        .tvs
        .map((e) => {...e, 'type': 'TV'})
        .toList();
    List allVideos = Provider.of<VODsProvider>(context, listen: false)
        .vods
        .map((e) => {...e, 'type': 'Video'})
        .toList();
    List allEvents = Provider.of<LiveEventsProvider>(context, listen: false)
        .events
        .map((e) => {...e, 'type': 'Event'})
        .toList();

    allContent = [...allTVs, ...allVideos, ...allEvents];
    allContent.shuffle();
    results = allContent;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: AllMediaSearchBar(
                controller: searchController,
                title: "Search TVs, Events & Videos",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "All Content",
                style: TextStyle(
                  color: white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Consumer<TVsProvider>(builder: (context, value, _) {
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: results.length >= 20
                    ? 20
                    : results.length, // 20, // value.events.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return Bounceable(
                    onTap: () {
                      dynamic mediaInfo = results[index];

                      // debugPrint(results[index]['type'].toString()),

                      if (results[index]['type'] == 'TV') {
                        WatchBridgeFunctions.watchLiveBridge(
                          id: mediaInfo['_id'],
                          watchLive: () {
                            showCupertinoModalBottomSheet(
                              topRadius: Radius.zero,
                              backgroundColor: black,
                              barrierColor: black,
                              context: context,
                              builder: (context) => MiniPlayerPopUp(
                                title: mediaInfo['name'],
                                videoUrl: mediaInfo['stream_key'],
                                data: mediaInfo,
                              ),
                            );
                          },
                          packages: [
                            "KiliyeEvents",
                            "KanemaSupa",
                            mediaInfo['name']
                          ],
                          contentName: mediaInfo['name'],
                          thumbnail: mediaInfo['thumb_nail'],
                          price: mediaInfo['price'] ?? 100,
                          isPublished: mediaInfo['status']['publish'] ?? false,
                        );
                      } else if (results[index]['type'] == 'Video') {
                        WatchBridgeFunctions.watchVideoBridge(
                          id: mediaInfo['_id'],
                          watchVideo: () {
                            showCupertinoModalBottomSheet(
                              topRadius: Radius.zero,
                              backgroundColor: black,
                              barrierColor: black,
                              context: context,
                              builder: (context) => MiniPlayerPopUp(
                                title: mediaInfo['name'],
                                videoUrl: mediaInfo['stream_key'],
                                data: mediaInfo,
                              ),
                            );
                          },
                          packages: [
                            "Kiliye Kiliye",
                            "KanemaFlex",
                            mediaInfo['name']
                          ],
                          contentName: mediaInfo['name'],
                          thumbnail: mediaInfo['thumb_nail'],
                          price: mediaInfo['price'] ?? 100,
                          isPublished: mediaInfo['status']['publish'] ?? false,
                        );
                      } else if (results[index]['type'] == 'Event') {
                        WatchBridgeFunctions.watchLiveBridge(
                          id: mediaInfo['_id'],
                          watchLive: () {
                            showCupertinoModalBottomSheet(
                              topRadius: Radius.zero,
                              backgroundColor: black,
                              barrierColor: black,
                              context: context,
                              builder: (context) => MiniPlayerPopUp(
                                title: mediaInfo['name'],
                                videoUrl: mediaInfo['stream_key'],
                                data: mediaInfo,
                              ),
                            );
                          },
                          packages: [
                            "KanemaSupa",
                            "KanemaEvents",
                            mediaInfo['name']
                          ],
                          contentName: mediaInfo['name'],
                          thumbnail: mediaInfo['thumb_nail'],
                          price: mediaInfo['price'] ?? 100,
                          isPublished: mediaInfo['status']['publish'] ?? false,
                        );
                      }
                    },
                    child: AspectRatio(
                      aspectRatio: 1 / 1.2,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: darkGrey.withOpacity(0.5),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                      results[index]['thumb_nail'],
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(7),
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
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    black.withOpacity(0.9),
                                    black.withOpacity(0.0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    results[index]['name'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: white,
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
                  );
                },
              );
            })
          ],
        ),
      ),
    );
  }
}
