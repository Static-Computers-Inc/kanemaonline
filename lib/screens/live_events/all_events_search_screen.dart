import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/fx/watch_bridge_functions.dart';
import 'package:kanemaonline/providers/live_events_provider.dart';
import 'package:kanemaonline/screens/players/mini_player_popup.dart';
import 'package:kanemaonline/screens/players/video_player.dart';
import 'package:kanemaonline/widgets/all_media_search_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class AllEventsSearchScreen extends StatefulWidget {
  const AllEventsSearchScreen({super.key});

  @override
  State<AllEventsSearchScreen> createState() => _AllEventsSearchScreenState();
}

class _AllEventsSearchScreenState extends State<AllEventsSearchScreen> {
  TextEditingController searchController = TextEditingController();
  late List allVideos;
  List results = [];

  searchListener() {
    if (searchController.text.isEmpty) {
      setState(() {
        results = allVideos;
      });
    } else {
      setState(() {
        results = allVideos
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
    allVideos = Provider.of<LiveEventsProvider>(
      context,
      listen: false,
    ).events;

    results = allVideos;
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
                title: "Search Live Events",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "All Live Events",
                style: TextStyle(
                  color: white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Consumer<LiveEventsProvider>(builder: (context, value, _) {
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
                    onTap: () => {
                      WatchBridgeFunctions.watchVideoBridge(
                        id: results[index]['_id'],
                        watchVideo: () {
                          showCupertinoModalBottomSheet(
                            topRadius: Radius.zero,
                            backgroundColor: black,
                            barrierColor: black,
                            context: context,
                            builder: (context) => MiniPlayerPopUp(
                              title: results[index]['name'],
                              videoUrl: results[index]['stream_key'],
                              data: results[index],
                            ),
                          );
                        },
                        packages: [
                          "Kanema Events",
                          "KanemaSupa",
                          results[index]['name']
                        ],
                        contentName: results[index]['name'],
                        thumbnail: results[index]['thumb_nail'],
                        price: results[index]['price'],
                        isPublished:
                            results[index]['status']['publish'] ?? false,
                      )
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
                                results[index]['thumb_nail'],
                              ),
                            ),
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
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
