import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/fx/watch_bridge_functions.dart';
import 'package:kanemaonline/providers/tvs_provider.dart';
import 'package:kanemaonline/screens/players/live_tvs_player.dart';
import 'package:kanemaonline/widgets/all_media_search_bar.dart';
import 'package:provider/provider.dart';

class AllTVsSearchScreen extends StatefulWidget {
  const AllTVsSearchScreen({super.key});

  @override
  State<AllTVsSearchScreen> createState() => _AllTVsSearchScreenState();
}

class _AllTVsSearchScreenState extends State<AllTVsSearchScreen> {
  TextEditingController searchController = TextEditingController();
  late List allTVs;
  List results = [];

  searchListener() {
    if (searchController.text.isEmpty) {
      setState(() {
        results = allTVs;
      });
    } else {
      setState(() {
        results = allTVs
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
    allTVs = Provider.of<TVsProvider>(
      context,
      listen: false,
    ).tvs;

    results = allTVs;
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
                title: "Search Live TVs",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "All Live TVs",
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
                    onTap: () => {
                      WatchBridgeFunctions.watchTVBridge(
                        contentName: results[index]['name'],
                        price: results[index]['price'],
                        watchTV: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => LiveTvsPlayerScreen(
                                name: results[index]['name'],
                                streamKey: results[index]['stream_key'],
                              ),
                            ),
                          );
                        },
                        packages: [
                          'Kiliye Kiliye',
                          'KanemaSupa',
                          results[index]['name'],
                        ],
                        thumbnail: results[index]['thumb_nail'],
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
