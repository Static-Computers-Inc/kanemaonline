import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';

class TrendingListSMWidget extends StatelessWidget {
  final List trending;
  final Function clickableAction;

  const TrendingListSMWidget({
    super.key,
    required this.trending,
    required this.clickableAction,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: transparent,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: trending.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                if (index == 0) const SizedBox(width: 15),
                Bounceable(
                  onTap: () => clickableAction(trending[index]),
                  child: AspectRatio(
                    aspectRatio: 1 / 1.2,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: darkGrey.withOpacity(0.5),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                  trending[index]['thumb_nail'],
                                ),
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                colors: [
                                  black.withOpacity(1),
                                  black.withOpacity(0.7),
                                  black.withOpacity(0.0),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              )),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trending[index]['name'],
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
                    ),
                  ),
                ),
                if (index == 4) const SizedBox(width: 15),
              ],
            );
          },
        ),
      ),
    );
  }
}
