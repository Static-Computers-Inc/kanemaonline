import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanemaonline/api/auth_api.dart';
import 'package:kanemaonline/data/countries.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/constants/input_decorations.dart';
import 'package:kanemaonline/helpers/validators/phone_email_validator.dart';
import 'package:kanemaonline/screens/auth/login.dart';
import 'package:kanemaonline/screens/auth/verify_account.dart';
import 'package:kanemaonline/screens/generics/choose_country_popup.dart';
import 'package:kanemaonline/widgets/bot_toasts.dart';
import 'package:kanemaonline/widgets/button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RegisterScreen extends StatefulWidget {
  final String region;
  const RegisterScreen({super.key, required this.region});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailOrPhonenumber = TextEditingController();
  TextEditingController region = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isRegistering = false;

  bool obscurePassword = false;

  bool? isFieldPhoneNumber;

  String countryCode = 'MW';

  void onSubmit() async {
    if (isRegistering) return;
    if (passwordController.text != confirmPasswordController.text) {
      BotToasts.showToast(message: "Passwords do not match", isError: true);
      return;
    }

    if (!formKey.currentState!.validate()) {
      return;
    } else {
      // Register account

      try {
        setState(() {
          isRegistering = true;
        });

        if (!isFieldPhoneNumber!) {
          countryCode = countries
              .where((element) => element['code'] == widget.region)
              .first['dial_code']
              .toString();
        } else {
          if (emailOrPhonenumber.text.trim().startsWith('0')) {
            BotToasts.showToast(
                message: "Phone number should not start with 0", isError: true);
            throw "";
          }
        }

        Map<dynamic, dynamic> body = await AuthAPI().register(
          userid: isFieldPhoneNumber!
              ? countries.firstWhere((element) =>
                      element['code'] == countryCode)['dial_code'] +
                  emailOrPhonenumber.text.trim()
              : emailOrPhonenumber.text.trim(),
          password: passwordController.text.trim(),
          name: 'User',
          region: countries.firstWhere(
              (element) => element['code'] == widget.region)['name'],
        );

        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => VerifyAccountScreen(
              phoneNumber: region.text.trim(),
              userId: body['message'][0]["_id"],
            ),
          ),
        );
      } catch (err) {
        setState(() {
          isRegistering = false;
        });
        debugPrint(err.toString());
      }

      setState(() {
        isRegistering = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    region.text =
        '${countries.firstWhere((element) => element['code'] == widget.region)['name']}';
  }

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
                  // height: MediaQuery.of(context).size.height * 0.55,
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
                        const SizedBox(height: 20),
                        const Text(
                          "Create Your Account",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: emailOrPhonenumber,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: authInputDecoration.copyWith(
                                  prefixIcon: isFieldPhoneNumber == null
                                      ? null
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14),
                                          child: isFieldPhoneNumber == null
                                              ? null
                                              : isFieldPhoneNumber!
                                                  ? GestureDetector(
                                                      onTap: () async {
                                                        var result =
                                                            await showCupertinoModalBottomSheet(
                                                          barrierColor: black
                                                              .withOpacity(0.8),
                                                          isDismissible: false,
                                                          context: context,
                                                          builder: (context) =>
                                                              const ChooseCountryPopup(),
                                                        );

                                                        if (result != null) {
                                                          setState(() {
                                                            countryCode =
                                                                result;
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
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : SvgPicture.asset(
                                                      "assets/svg/email.svg",
                                                      width: 10,
                                                      color: darkGrey,
                                                    ),
                                        ),
                                  hintText: "Email Address / Phone Number",
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
                                validator: (value) =>
                                    PhoneEmailValidator.validateEmailOrPhone(
                                  value: countries.firstWhere((element) =>
                                          element['code'] ==
                                          countryCode)['dial_code'] +
                                      value!,
                                  isoCode: countryCode,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ////////////
                              TextFormField(
                                controller: region,
                                enabled: false,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: authInputDecoration.copyWith(
                                  prefixIcon: SizedBox(
                                    width: 16,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14),
                                      child: Center(
                                        child: Text(
                                          countries.firstWhere((element) =>
                                              element['code'] ==
                                              widget.region)['flag'],
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                  hintText: "Region",
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: passwordController,
                                obscureText: !obscurePassword,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: authInputDecoration.copyWith(
                                  hintText: "Password",
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        obscurePassword = !obscurePassword;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14),
                                      child: Icon(
                                        obscurePassword
                                            ? CupertinoIcons.eye
                                            : CupertinoIcons.eye_slash,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: SvgPicture.asset(
                                      "assets/svg/password.svg",
                                      width: 10,
                                      color: darkGrey,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: confirmPasswordController,
                                obscureText: true,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: authInputDecoration.copyWith(
                                  hintText: "Confirm Password",
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: SvgPicture.asset(
                                      "assets/svg/password.svg",
                                      width: 10,
                                      color: darkGrey,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              const SizedBox(height: 20),
                              Button(
                                text: isRegistering
                                    ? "Registering..."
                                    : "Register",
                                onTap: () => onSubmit(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          children: [
                            const Text(
                              "Already have an account?",
                            ),
                            const SizedBox(width: 3),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: red,
                                ),
                              ),
                            )
                          ],
                        ),
                        SafeArea(
                          top: false,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
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
