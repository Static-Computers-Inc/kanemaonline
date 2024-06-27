// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanemaonline/api/mylist_api.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/fx/betterlogger.dart';
import 'package:kanemaonline/providers/my_list_provider.dart';
import 'package:kanemaonline/widgets/bot_toasts.dart';
import 'package:provider/provider.dart';

class HeroWidget extends StatefulWidget {
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
  _HeroWidgetState createState() => _HeroWidgetState();
}

class _HeroWidgetState extends State<HeroWidget> {
  ValueNotifier<bool> loading = ValueNotifier(false);
  ValueNotifier<bool> isInList = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    checkIsInList();
  }

  checkIsInList() {
    List value = Provider.of<MyListProvider>(context, listen: false).myList;

    isInList.value = value.any(
      (element) => element["_id"] == widget.itemId,
    );

    isInList.notifyListeners();
  }

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
            image: CachedNetworkImageProvider(widget.imageUrl),
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
      onTap: () => widget.playAction(),
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
      onTap: () => widget.myListAction(),
      child: Consumer<MyListProvider>(
        builder: (context, value, child) {
          checkIsInList();

          return ValueListenableBuilder(
              valueListenable: isInList,
              builder: (context, value, _) {
                return GestureDetector(
                  onTap: () async {
                    if (value) {
                      try {
                        await MyListAPI().removeItem(id: widget.itemId);
                        BotToasts.showToast(
                          message: "Removed from My List",
                          isError: false,
                        );
                        loading.value = false;
                        isInList.value = false;
                        isInList.notifyListeners();
                        Provider.of<MyListProvider>(context, listen: false)
                            .init();
                      } catch (err) {
                        loading.value = false;
                        BotToasts.showToast(
                          message: "Failed to remove item from My List",
                          isError: true,
                        );
                        console.log(err.toString());
                      }
                      return;
                    }

                    try {
                      loading.value = true;
                      bool result =
                          await MyListAPI().addItem(id: widget.itemId);
                      BotToasts.showToast(
                        message: "Added to My List",
                        isError: false,
                      );
                      debugPrint(result.toString());
                      isInList.value = false;
                      isInList.notifyListeners();
                      loading.value = false;
                      if (result) {
                        Provider.of<MyListProvider>(context, listen: false)
                            .init();
                      }
                    } catch (err) {
                      debugPrint(err.toString());
                      loading.value = false;
                    }
                    debugPrint(widget.itemId);
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
                        ValueListenableBuilder<bool>(
                          valueListenable: loading,
                          builder: (context, value, _) {
                            return Builder(
                              builder: (context) {
                                if (value) {
                                  return SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      color: white,
                                      strokeWidth: 2,
                                    ),
                                  );
                                } else {
                                  return value
                                      ? SvgPicture.asset(
                                          "assets/svg/check.svg",
                                          key: ValueKey(value),
                                          color: green,
                                          width: 24,
                                        )
                                      : SvgPicture.asset(
                                          "assets/svg/add.svg",
                                          key: ValueKey(!value),
                                          width: 24,
                                          color: white,
                                        );
                                }
                              },
                            );
                          },
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
              });
        },
      ),
    );
  }

  Widget _buildInfoButton() {
    return Bounceable(
      onTap: () => widget.infoAction(),
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
