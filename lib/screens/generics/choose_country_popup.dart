import 'package:flutter/material.dart';
import 'package:kanemaonline/data/countries.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';

class ChooseCountryPopup extends StatefulWidget {
  const ChooseCountryPopup({super.key});

  @override
  State<ChooseCountryPopup> createState() => _ChooseCountryPopupState();
}

class _ChooseCountryPopupState extends State<ChooseCountryPopup> {
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
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close),
        ),
        centerTitle: true,
        title: const Text(
          "Select your region to get started",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: lightGrey,
                ),
                child: SizedBox(
                  child: TextFormField(
                    controller: searchText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                        hintText: "Search by country name",
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 14,
                        )),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: allCountries.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => {
                      Navigator.pop(context, allCountries[index]['code']),
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      decoration: const BoxDecoration(),
                      child: Row(
                        children: [
                          Text(
                            allCountries[index]['flag'].toString(),
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.57,
                            child: Text(
                              allCountries[index]['name'].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(child: Container()),
                          Text(
                            allCountries[index]['dial_code'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
