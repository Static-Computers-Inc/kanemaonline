import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/fx/watch_bridge_functions.dart';
import 'package:kanemaonline/providers/vods_provider.dart';
import 'package:kanemaonline/screens/players/video_player.dart';
import 'package:kanemaonline/widgets/trending_list_sm_widget.dart';
import 'package:provider/provider.dart';

class SingleVideoDetails extends StatefulWidget {
  final dynamic data;
  const SingleVideoDetails({super.key, required this.data});

  @override
  State<SingleVideoDetails> createState() => _SingleVideoDetailsState();
}

class _SingleVideoDetailsState extends State<SingleVideoDetails> {
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
              _buildPlayButton(),
              _buildDescription(),
              _buildActions(),
              _buildRelatedVideos(),
            ],
          ),
        ));
  }

  Widget _buildTimeAndLocation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Text(
            DateFormat("dd MMM, yyyy")
                .format(DateTime.parse(widget.data['created_at'])),
            style: TextStyle(
              color: white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          Text(
            " - ",
            style: TextStyle(
              color: white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
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
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.35,
          width: double.infinity,
          decoration: BoxDecoration(
            color: red,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                widget.data['thumb_nail'],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.35 / 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  black.withOpacity(0.0),
                  black.withOpacity(0.5),
                  black,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
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
        ),
      ],
    );
  }

  Widget _buildPlayButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: GestureDetector(
        onTap: () {
          WatchBridgeFunctions.watchVideoBridge(
            watchVideo: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => VideoPlayerScreen(
                  videoUrl: widget.data['stream_key'],
                  title: widget.data['name'],
                ),
              ),
            ),
            packages: [
              'KanemaFlex',
              'KanemaSupa',
              widget.data['name'],
            ],
            contentName: widget.data['name'],
            thumbnail: widget.data['thumb_nail'],
            price: widget.data['price'],
            isPublished: widget.data['status']['publish'],
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          decoration: BoxDecoration(
              color: red, borderRadius: BorderRadius.circular(55)),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/svg/play_special.svg"),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "Play",
                  style: TextStyle(
                    color: white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildRelatedVideos() {
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
          Consumer<VODsProvider>(builder: (context, value, child) {
            return TrendingListSMWidget(
              trending: value.vods.getRange(0, 5).toList(),
              clickableAction: (data) => {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => SingleVideoDetails(
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
