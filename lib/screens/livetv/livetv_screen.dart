import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/providers/tvs_provider.dart';
import 'package:provider/provider.dart';

class LiveTVScreen extends StatefulWidget {
  const LiveTVScreen({super.key});

  @override
  State<LiveTVScreen> createState() => _LiveTVScreenState();
}

class _LiveTVScreenState extends State<LiveTVScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: white.withOpacity(0),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<TVsProvider>(builder: (context, value, _) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: white,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            value.tvs[2]['thumb_nail'],
                          ),
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: double.infinity,
                      ))
                ],
              );
            }),
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
                        return Container(
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: CachedNetworkImageProvider(
                                  tvsProvider.tvs[index]['thumb_nail']),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
                Positioned(
                  left: 15,
                  top: 25,
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
    );
  }
}
