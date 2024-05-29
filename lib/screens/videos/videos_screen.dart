import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/fx/watch_bridge_functions.dart';
import 'package:kanemaonline/providers/my_list_provider.dart';
import 'package:kanemaonline/providers/vods_provider.dart';
import 'package:kanemaonline/screens/details_pages/single_video_details.dart';
import 'package:kanemaonline/screens/players/video_player.dart';
import 'package:kanemaonline/screens/videos/all_videos_search_screen.dart';
import 'package:kanemaonline/widgets/error_widget.dart';
import 'package:kanemaonline/widgets/hero_search_appbar.dart';
import 'package:kanemaonline/widgets/hero_widget.dart';
import 'package:kanemaonline/widgets/scaffold_wrapper.dart';
import 'package:kanemaonline/widgets/trending_list_sm_widget.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  PaletteGenerator? paletteGenerator;

  @override
  void initState() {
    super.initState();
  }

  bool paletteGenerated = false;

  void _generatePalette({required String image}) async {
    if (paletteGenerated) return;
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(image),
      maximumColorCount: 20,
    );
    paletteGenerated = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      toolbarColor:
          paletteGenerator?.darkMutedColor?.color ?? const Color(0x0000ffff),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: HeroSearchAppBar.appBar(searchOnTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const AllVideosSearchScreen(),
            ),
          );
        }),
        body: Consumer<VODsProvider>(
          builder: (context, value, child) {
            if (!value.isLoading) {
              _generatePalette(
                image: value.vods[0]['thumb_nail'],
              );
            }
            return value.isLoading
                ? Center(
                    child: CupertinoActivityIndicator(
                      color: white,
                      radius: 14,
                    ),
                  )
                : value.vods.isEmpty
                    ? RetryErrorWidget(
                        onRetry: () {
                          Provider.of<VODsProvider>(
                            context,
                            listen: false,
                          ).init();
                        },
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeroWidget(
                              mediaInfo: value.vods[0],
                            ),
                            _buildTrendingWidget(trending: value.vods),
                            _buildVideosWidget(trending: value.vods),
                            //
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            //
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
        WatchBridgeFunctions.watchVideoBridge(
          watchVideo: () {
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
          packages: [
            'KanemaFlex',
            'KanemaSupa',
            mediaInfo['name'],
          ],
          contentName: mediaInfo['name'],
          thumbnail: mediaInfo['thumb_nail'],
          price: mediaInfo['price'],
          isPublished: mediaInfo['status']['publish'],
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
      infoAction: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SingleVideoDetails(
              data: mediaInfo,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrendingWidget({required List trending}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Text(
            "What others are watching",
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
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SingleVideoDetails(data: data),
                ),
              );
              // WatchBridgeFunctions.watchVideoBridge(
              //   watchVideo: () {
              //     Navigator.push(
              //       context,
              //       CupertinoPageRoute(
              //         builder: (context) => VideoPlayerScreen(
              //           videoUrl: data['stream_key'],
              //           title: data['name'],
              //         ),
              //       ),
              //     );
              //   },
              //   packages: [
              //     'KanemaFlex',
              //     'KanemaSupa',
              //     data['name'],
              //   ],
              //   contentName: data['name'],
              //   thumbnail: data['thumb_nail'],
              //   price: data['price'],
              //   isPublished: data['publish'],
              // );
            }),
      ],
    );
  }

  Widget _buildVideosWidget({required List trending}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "All Videos",
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
                      builder: (context) => const AllVideosSearchScreen(),
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
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SingleVideoDetails(data: data),
                ),
              );
            }),
      ],
    );
  }
}
