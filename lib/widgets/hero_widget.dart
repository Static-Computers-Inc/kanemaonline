import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanemaonline/api/mylist_api.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/providers/my_list_provider.dart';
import 'package:provider/provider.dart';

class HeroWidget extends StatelessWidget {
  final String itemId;
  final String imageUrl;
  final Function playAction;
  final Function myListAction;
  final Function infoAction;
  const HeroWidget({
    super.key,
    required this.imageUrl,
    required this.playAction,
    required this.myListAction,
    required this.infoAction,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: red,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(imageUrl),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      black,
                      transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _buildPlayButton(),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: _buildMyListButton(),
                        ),
                        _buildInfoButton(),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return Bounceable(
      onTap: () => playAction(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: red,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/svg/play_special.svg",
              width: 23,
            ),
            const SizedBox(width: 5),
            Text(
              'Play',
              style: TextStyle(
                color: white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyListButton() {
    return Bounceable(
      onTap: () => myListAction(),
      child: Consumer<MyListProvider>(
        builder: (context, value, child) {
          bool isInList = value.myList.any(
            (element) => element["id"] == itemId,
          );
          return GestureDetector(
            onTap: () async {
              try {
                bool result = await MyListAPI().addItem(id: itemId);
                debugPrint(result.toString());
                if (result) {
                  Provider.of<MyListProvider>(context, listen: false).init();
                }
              } catch (err) {
                debugPrint(err.toString());
              }
              debugPrint(itemId);
            },
            child: BlurryContainer(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              borderRadius: BorderRadius.circular(4),
              color: white.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isInList
                      ? SvgPicture.asset(
                          "assets/svg/check.svg",
                          key: ValueKey(isInList),
                          color: white,
                          width: 24,
                        )
                      : SvgPicture.asset(
                          "assets/svg/add.svg",
                          key: ValueKey(!isInList),
                          width: 24,
                          color: white,
                        ),
                  const SizedBox(width: 5),
                  Text(
                    'My List',
                    style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoButton() {
    return Bounceable(
      onTap: () => infoAction(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/svg/info.svg",
              color: white,
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
