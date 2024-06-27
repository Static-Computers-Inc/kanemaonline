import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanemaonline/api/auth_api.dart';
import 'package:kanemaonline/data/countries.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/constants/input_decorations.dart';
import 'package:kanemaonline/helpers/validators/phone_email_validator.dart';
import 'package:kanemaonline/screens/generics/choose_country_popup.dart';
import 'package:kanemaonline/screens/profile_screens/account/verify_credential_change.dart';
import 'package:kanemaonline/widgets/activity_loading_widget.dart';
import 'package:kanemaonline/widgets/bot_toasts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class UpdatePhonenumberScreen extends StatefulWidget {
  const UpdatePhonenumberScreen({super.key});

  @override
  State<UpdatePhonenumberScreen> createState() =>
      _UpdatePhonenumberScreenState();
}

class _UpdatePhonenumberScreenState extends State<UpdatePhonenumberScreen> {
  TextEditingController emailController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  bool isFieldPhoneNumber = true;

  String countryCode = 'MW';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Phone number"),
      ),
      body: isLoading
          ? const CustomIndicatorWidget()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: TextFormField(
                        controller: emailController,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        onChanged: (value) async {
                          try {
                            PhoneNumberUtil.instance.parse(value, 'MW');
                            isFieldPhoneNumber = true;
                            setState(() {});
                          } catch (err) {
                            isFieldPhoneNumber = false;
                            setState(() {});
                          }
                        },
                        decoration: authInputDecoration.copyWith(
                          prefixIcon: isFieldPhoneNumber == null
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  child: isFieldPhoneNumber == null
                                      ? null
                                      : isFieldPhoneNumber
                                          ? GestureDetector(
                                              onTap: () async {
                                                var result =
                                                    await showCupertinoModalBottomSheet(
                                                  barrierColor:
                                                      black.withOpacity(0.8),
                                                  isDismissible: false,
                                                  context: context,
                                                  builder: (context) =>
                                                      const ChooseCountryPopup(),
                                                );

                                                if (result != null) {
                                                  setState(() {
                                                    countryCode = result;
                                                  });
                                                }
                                              },
                                              child: SizedBox(
                                                // width: MediaQuery.of(
                                                //             context)
                                                //         .size
                                                //         .width *
                                                //     0.1,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      CupertinoIcons
                                                          .chevron_down,
                                                      size: 15,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      countries
                                                          .firstWhere(
                                                              (element) =>
                                                                  element[
                                                                      'code'] ==
                                                                  countryCode)[
                                                              'dial_code']
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : SvgPicture.asset(
                                              "assets/svg/phone.svg",
                                              width: 10,
                                              color: darkGrey,
                                            ),
                                ),
                          hintText: "Phone Number",
                        ),
                        validator: (value) =>
                            PhoneEmailValidator.validateEmailOrPhone(
                          value: countries.firstWhere((element) =>
                                  element['code'] == countryCode)['dial_code'] +
                              value!,
                          isoCode: countryCode,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        isLoading = true;
                        setState(() {});
                        try {
                          if (!isFieldPhoneNumber) {
                            BotToasts.showToast(
                              message: "Please input a phone number",
                              isError: true,
                            );
                            isLoading = false;
                            setState(() {});
                            throw "PhoneNumber only";
                          }

                          if (emailController.value.text.startsWith('0')) {
                            BotToasts.showToast(
                              message: "Phone number should not start with '0'",
                              isError: true,
                            );
                            isLoading = false;
                            setState(() {});
                            throw "Phone number cannot start with 0";
                          }

                          await AuthAPI().verifyProfile(
                            credential: isFieldPhoneNumber
                                ? countries
                                        .firstWhere((element) =>
                                            element['code'] ==
                                            countryCode)['dial_code']
                                        .toString() +
                                    emailController.text.trim()
                                : emailController.text.trim(),
                          );

                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => VerifyCredentialOTP(
                                credential: emailController.text.trim(),
                                isPhonenumber: true,
                              ),
                            ),
                          );
                        } catch (err) {
                          debugPrint(err.toString());
                          isLoading = false;
                          setState(() {});
                        }

                        isLoading = false;
                        setState(() {});
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(100)),
                        child: const Center(
                          child: Text(
                            "Change Phone Number",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
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
