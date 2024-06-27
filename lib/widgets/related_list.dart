import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';

class RelatedVideosList extends StatelessWidget {
  final List<dynamic> trending;
  final Function clickableAction;
  const RelatedVideosList(
      {super.key, required this.trending, required this.clickableAction});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: trending.length,
          itemBuilder: (context, index) {
            return Bounceable(
              onTap: () => clickableAction(trending[index]),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: darkerAccent,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                trending[index]['thumb_nail'],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: Text(
                            trending[index]['name'],
                            style: TextStyle(
                              color: white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: Text(
                            trending[index]['description'],
                            style: TextStyle(
                              color: white.withOpacity(0.65),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
