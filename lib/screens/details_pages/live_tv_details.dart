import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/fx/watch_bridge_functions.dart';
import 'package:kanemaonline/providers/live_events_provider.dart';
import 'package:kanemaonline/providers/tvs_provider.dart';
import 'package:kanemaonline/providers/vods_provider.dart';
import 'package:kanemaonline/screens/players/live_tvs_player.dart';
import 'package:kanemaonline/screens/players/video_player.dart';
import 'package:kanemaonline/widgets/trending_list_sm_widget.dart';
import 'package:provider/provider.dart';

class SingleTVDetails extends StatefulWidget {
  final dynamic data;
  const SingleTVDetails({super.key, required this.data});

  @override
  State<SingleTVDetails> createState() => _SingleTVDetailsState();
}

class _SingleTVDetailsState extends State<SingleTVDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.only(right: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: black.withOpacity(0.5),
              ),
              child: Center(child: Icon(CupertinoIcons.back, color: white)),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(),
            _buildTimeAndLocation(),
            _buildDescription(),
            _buildActions(),
            _buildMalawiDigital(),
            _buildRelatedEvents(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeAndLocation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          // Text(
          //   DateFormat("dd MMM, yyyy")
          //       .format(DateTime.parse(widget.data['created_at'])),
          //   style: TextStyle(
          //     color: white,
          //     fontWeight: FontWeight.w700,
          //     fontSize: 12,
          //   ),
          // ),
          // Text(
          //   " - ",
          //   style: TextStyle(
          //     color: white,
          //     fontWeight: FontWeight.w700,
          //     fontSize: 12,
          //   ),
          // ),
          Text(
            "Location",
            style: TextStyle(
              color: white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: double.infinity,
              decoration: BoxDecoration(
                color: white,
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: CachedNetworkImageProvider(
                    widget.data['thumb_nail'],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: black.withOpacity(0.35),
                ),
                child: SafeArea(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        WatchBridgeFunctions.watchTVBridge(
                          watchTV: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => LiveTvsPlayerScreen(
                                  name: "${widget.data['name']}",
                                  streamKey: widget.data['stream_key'],
                                ),
                              ),
                            );
                          },
                          contentName: widget.data['name'],
                          thumbnail: widget.data['thumb_nail'],
                          price: widget.data['price'],
                          packages: [
                            "KanemaSupa",
                            "Kiliye Kiliye",
                            widget.data['name']
                          ],
                          isPublished: widget.data['status']['publish'],
                        );
                      },
                      child: SvgPicture.asset(
                        "assets/svg/play_special.svg",
                        width: 60,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                black.withOpacity(0.0),
                black.withOpacity(0.5),
                black,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [
                0.0,
                0.5,
                0.5,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.data['name'],
                  style: TextStyle(
                    color: white,
                    fontWeight: FontWeight.w700,
                    fontSize: 19,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      child: Text(
        widget.data['description'],
        style: TextStyle(
          color: white,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              SvgPicture.asset(
                "assets/svg/play_outline.svg",
                color: white,
                height: 23,
              ),
              const SizedBox(height: 8),
              Text(
                "Trailer",
                style: TextStyle(
                  color: white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Column(
            children: [
              SvgPicture.asset(
                "assets/svg/add.svg",
                color: white,
                height: 23,
              ),
              const SizedBox(height: 8),
              Text(
                "My List",
                style: TextStyle(
                  color: white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Column(
            children: [
              SvgPicture.asset(
                "assets/svg/share.svg",
                color: white,
                height: 23,
              ),
              const SizedBox(height: 8),
              Text(
                "Share",
                style: TextStyle(
                  color: white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMalawiDigital() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Powered By",
            style: TextStyle(color: white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 15),
          SizedBox(width: 40, child: Image.asset("assets/images/mdbnl.png")),
        ],
      ),
    );
  }

  Widget _buildRelatedEvents() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Related".toUpperCase(),
              style: TextStyle(
                color: white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Consumer<TVsProvider>(builder: (context, value, child) {
            return TrendingListSMWidget(
              trending: value.tvs.getRange(0, 5).toList(),
              clickableAction: (data) => {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => SingleTVDetails(
                      data: data,
                    ),
                  ),
                ),
              },
            );
          })
        ],
      ),
    );
  }
}
