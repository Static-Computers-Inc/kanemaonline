import 'package:flutter/material.dart';
import 'package:kanemaonline/data/countries.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';

class ChooseRegionPopup extends StatefulWidget {
  const ChooseRegionPopup({super.key});

  @override
  State<ChooseRegionPopup> createState() => _ChooseRegionPopupState();
}

class _ChooseRegionPopupState extends State<ChooseRegionPopup> {
  TextEditingController searchText = TextEditingController();
  List allCountries = countries;
  searchListener() {
    if (searchText.text.isEmpty) {
      setState(() {
        allCountries = countries;
      });
      return;
    }
    setState(() {
      allCountries = countries
          .where((country) => country['name']
              .toString()
              .toLowerCase()
              .contains(searchText.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    searchText.addListener(searchListener);
  }

  @override
  Widget build(BuildContext context) {
    var modifiedList = allCountries
        .where((country) =>
            country['code'] == 'MW' ||
            country['code'] == 'ZM' ||
            country['code'] == 'KE' ||
            country['code'] == 'ZW')
        .toList();
    return Material(
      color: black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Select your region",
                  style: TextStyle(
                      fontSize: 16, color: white, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 25),
            ListView.builder(
              itemCount: modifiedList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                debugPrint(modifiedList.toString());
                return GestureDetector(
                  onTap: () => {
                    Navigator.pop(context, modifiedList[index]['code']),
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 7,
                    ),
                    decoration: const BoxDecoration(),
                    child: Row(
                      children: [
                        Text(
                          modifiedList[index]['flag'].toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 15),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.57,
                          child: Text(
                            modifiedList[index]['name'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ],
        ),
      ),
    );
  }
}
