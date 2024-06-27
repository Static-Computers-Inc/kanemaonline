import 'package:dlibphonenumber/phone_number_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanemaonline/api/auth_api.dart';
import 'package:kanemaonline/data/countries.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/constants/input_decorations.dart';
import 'package:kanemaonline/helpers/validators/phone_email_validator.dart';
import 'package:kanemaonline/screens/auth/verify_password_reset_otp.dart';
import 'package:kanemaonline/screens/generics/choose_country_popup.dart';
import 'package:kanemaonline/widgets/bot_toasts.dart';
import 'package:kanemaonline/widgets/button.dart';
import 'package:kanemaonline/widgets/overlay_loader.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isLoading = false;
  TextEditingController controller = TextEditingController();

  bool? isFieldPhoneNumber = false;

  String countryCode = 'MW';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  onSubmit() async {
    isLoading = true;

    var credential = !isFieldPhoneNumber!
        ? controller.text.trim()
        : countries.firstWhere(
                (element) => element['code'] == countryCode)['dial_code'] +
            controller.text.trim();

    setState(() {});
    if (formKey.currentState!.validate()) {
      debugPrint("Reseting password");
      try {
        await AuthAPI().forgotPassword(
          userId: credential,
        );
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => VerifyPasswordOTP(credential: credential),
          ),
        );
      } catch (err) {
        BotToasts.showText(message: err.toString());
      }
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: transparent,
      ),
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
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05),
                            const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // const Text("Don't worry! it happens."),
                            const Text(
                              "Please enter the email address or phone number associated with your account.",
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            _buildForms(),
                            // const SizedBox(height: 10),
                            // const SizedBox(height: 20),
                            Button(
                              text: isLoading
                                  ? "Reseting Password.."
                                  : "Reset Password",
                              onTap: () => onSubmit(),
                            ),

                            const SizedBox(height: 30),
                            Wrap(
                              children: [
                                const Text("Rembered Password?"),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                          ],
                        ),
                      ),
                      isLoading ? const OverlayLoader() : Container(),
                    ],
                  ),
                ),
              ),

              //
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForms() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: controller,
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
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: isFieldPhoneNumber == null
                          ? null
                          : isFieldPhoneNumber!
                              ? GestureDetector(
                                  onTap: () async {
                                    var result =
                                        await showCupertinoModalBottomSheet(
                                      barrierColor: black.withOpacity(0.8),
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
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          CupertinoIcons.chevron_down,
                                          size: 15,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          countries
                                              .firstWhere((element) =>
                                                  element['code'] ==
                                                  countryCode)['dial_code']
                                              .toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
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
            validator: (value) => PhoneEmailValidator.validateEmailOrPhone(
              value: countries.firstWhere((element) =>
                      element['code'] == countryCode)['dial_code'] +
                  value!,
              isoCode: countryCode,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
