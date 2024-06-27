// ignore_for_file: use_build_context_synchronously

import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanemaonline/api/auth_api.dart';
import 'package:kanemaonline/data/countries.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/constants/input_decorations.dart';
import 'package:kanemaonline/helpers/validators/phone_email_validator.dart';
import 'package:kanemaonline/screens/profile_screens/account/verify_credential_change.dart';
import 'package:kanemaonline/widgets/activity_loading_widget.dart';
import 'package:kanemaonline/widgets/bot_toasts.dart';

class EditPhonenumberEmail extends StatefulWidget {
  const EditPhonenumberEmail({super.key});

  @override
  State<EditPhonenumberEmail> createState() => _EditPhonenumberEmailState();
}

class _EditPhonenumberEmailState extends State<EditPhonenumberEmail> {
  TextEditingController emailController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  bool isFieldPhoneNumber = false;

  String countryCode = 'MW';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Email"),
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
                                      : SvgPicture.asset(
                                          "assets/svg/email.svg",
                                          width: 10,
                                          color: darkGrey,
                                        ),
                                ),
                          hintText: "Email Address",
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
                        if (isFieldPhoneNumber) {
                          BotToasts.showToast(
                            message: "Please input an email address",
                            isError: true,
                          );
                          return;
                        }

                        isLoading = true;
                        setState(() {});
                        try {
                          await AuthAPI().verifyProfile(
                            credential: emailController.text.trim(),
                          );

                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => VerifyCredentialOTP(
                                credential: emailController.text.trim(),
                                isPhonenumber: false,
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
                            "Update Email Address",
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
