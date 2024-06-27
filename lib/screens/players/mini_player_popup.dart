import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/fx/watch_bridge_functions.dart';
import 'package:kanemaonline/providers/live_events_provider.dart';
import 'package:kanemaonline/providers/tvs_provider.dart';
import 'package:kanemaonline/providers/vods_provider.dart';
import 'package:kanemaonline/widgets/miniplayer/video_player_mini_player.dart';
import 'package:kanemaonline/widgets/related_list.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:see_more/see_more_widget.dart';

class MiniPlayerPopUp extends StatefulWidget {
  final String title;
  final String videoUrl;
  final Map<dynamic, dynamic> data;

  const MiniPlayerPopUp({
    super.key,
    required this.title,
    required this.videoUrl,
    required this.data,
  });

  @override
  State<MiniPlayerPopUp> createState() => _MiniPlayerPopUpState();
}

class _MiniPlayerPopUpState extends State<MiniPlayerPopUp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkerAccent.withOpacity(0.35),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: MiniVideoPlayer(
              title: widget.title,
              videoUrl: widget.videoUrl,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                _buildVideoDetails(),
                _buildActionButtons(),
                _buildRelatedVideos(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoDetails() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Text(
              widget.data['name'],
              style: TextStyle(
                  color: white, fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            SeeMoreWidget(
              widget.data['description'] ?? widget.data['name'],
              trimLength: 100,
              animationDuration: const Duration(
                milliseconds: 100,
              ),
              textStyle: TextStyle(
                color: white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              seeMoreStyle: TextStyle(
                color: green,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              seeLessStyle: TextStyle(
                color: green,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ));
  }

  Widget _buildActionButtons() {
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
          _actionDivider(),
          Column(
            children: [
              SvgPicture.asset(
                "assets/svg/comment.svg",
                color: white,
                height: 23,
              ),
              const SizedBox(height: 8),
              Text(
                "Comment",
                style: TextStyle(
                  color: white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          _actionDivider(),
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
          _actionDivider(),
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

  Widget _actionDivider() {
    return Container(
      width: 2,
      height: 25,
      decoration: BoxDecoration(color: darkAccent.withOpacity(0.3)),
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
          Builder(
            builder: (context) => widget.data['category'] == "events"
                ? _eventsList()
                : widget.data['category'] == "tvs"
                    ? _tvsList()
                    : _vodsList(),
          ),
        ],
      ),
    );
  }

  Widget _vodsList() {
    return Consumer<VODsProvider>(
      builder: (context, value, child) {
        return RelatedVideosList(
          trending: value.vods.getRange(0, 5).toList(),
          clickableAction: (data) => {
            WatchBridgeFunctions.watchLiveBridge(
              id: data['_id'],
              watchLive: () {
                Navigator.pop(context);
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
              packages: ["KanemaFlex", "KanemaSupa", data['name']],
              contentName: data['name'],
              thumbnail: data['thumb_nail'],
              price: data['price'],
              isPublished: data['status']['publish'],
            ),
          },
        );
      },
    );
  }

  Widget _eventsList() {
    return Consumer<LiveEventsProvider>(
      builder: (context, value, child) {
        return RelatedVideosList(
          trending: value.events.getRange(0, 5).toList(),
          clickableAction: (data) => {
            WatchBridgeFunctions.watchLiveBridge(
              id: data['_id'],
              watchLive: () {
                Navigator.pop(context);
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
              packages: ["Kanema Events", "KanemaSupa", data['name']],
              contentName: data['name'],
              thumbnail: data['thumb_nail'],
              price: data['price'],
              isPublished: data['status']['publish'] ?? false,
            ),
          },
        );
      },
    );
  }

  Widget _tvsList() {
    return Consumer<TVsProvider>(
      builder: (context, value, child) {
        return RelatedVideosList(
          trending: value.tvs.getRange(0, 5).toList(),
          clickableAction: (data) => {
            WatchBridgeFunctions.watchTVBridge(
              id: data['_id'],
              watchTV: () {
                Navigator.pop(context);
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
              packages: ["Kiliye Kiliye", "KanemaSupa", data['name']],
              contentName: data['name'],
              thumbnail: data['thumb_nail'],
              price: data['price'],
              isPublished: data['status']['publish'],
            ),
          },
        );
      },
    );
  }
}
