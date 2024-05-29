import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/fx/watch_bridge_functions.dart';
import 'package:kanemaonline/providers/vods_provider.dart';
import 'package:kanemaonline/screens/players/video_player.dart';
import 'package:kanemaonline/widgets/all_media_search_bar.dart';
import 'package:provider/provider.dart';

class AllVideosSearchScreen extends StatefulWidget {
  const AllVideosSearchScreen({super.key});

  @override
  State<AllVideosSearchScreen> createState() => _AllVideosSearchScreenState();
}

class _AllVideosSearchScreenState extends State<AllVideosSearchScreen> {
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
    allVideos = Provider.of<VODsProvider>(
      context,
      listen: false,
    ).vods;

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
                title: "Search Videos",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "All Videos",
                style: TextStyle(
                  color: white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<VODsProvider>(builder: (context, value, _) {
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: results.length, // value.events.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    return Bounceable(
                      onTap: () => {
                        WatchBridgeFunctions.watchVideoBridge(
                          watchVideo: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => VideoPlayerScreen(
                                  title: results[index]['name'],
                                  videoUrl: results[index]['stream_key'],
                                ),
                              ),
                            );
                          },
                          packages: [
                            "KanemaFlex",
                            "KanemaSupa",
                            results[index]['name']
                          ],
                          contentName: results[index]['name'],
                          thumbnail: results[index]['thumb_nail'],
                          price: results[index]['price'],
                          isPublished: results[index]['publish'],
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
              }),
            )
          ],
        ),
      ),
    );
  }
}
