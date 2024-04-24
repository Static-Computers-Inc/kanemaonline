import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanemaonline/data/countries.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/screens/generics/choose_country_popup.dart';
import 'package:kanemaonline/screens/screens.dart';
import 'package:kanemaonline/widgets/button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ChooseCountry extends StatefulWidget {
  const ChooseCountry({super.key});

  @override
  State<ChooseCountry> createState() => _ChooseCountryState();
}

class _ChooseCountryState extends State<ChooseCountry> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String selectedCode = "MW";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/landing.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(color: Colors.black54),
          child: Stack(
            children: [
              //  LOGO
              AspectRatio(
                aspectRatio: 1 / 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.2,
                  ),
                  child: Image.asset("assets/images/logo-white.png"),
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        const Text(
                          "Select Your Region",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {
                            var result = await showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) => const ChooseCountryPopup(),
                            );

                            if (result != null) {
                              setState(() {
                                selectedCode = result;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: lightGrey,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(children: [
                              Text(
                                countries
                                    .where((element) =>
                                        element['code'] == selectedCode)
                                    .first['flag']
                                    .toString(),
                              ),
                              const SizedBox(width: 5),
                              const Icon(
                                CupertinoIcons.chevron_down,
                                size: 14,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                countries
                                    .where((element) =>
                                        element['code'] == selectedCode)
                                    .first['name']
                                    .toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Button(
                          text: "Continue",
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => RegisterScreen(
                                  code: selectedCode,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
