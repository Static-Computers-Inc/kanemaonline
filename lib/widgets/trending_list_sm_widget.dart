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
                      child: Container(
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
