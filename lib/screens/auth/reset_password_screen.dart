// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/constants/input_decorations.dart';
import 'package:kanemaonline/helpers/fx/providers_init.dart';

import 'package:kanemaonline/api/auth_api.dart';
import 'package:kanemaonline/widgets/bot_toasts.dart';
import 'package:kanemaonline/widgets/button.dart';
import 'package:kanemaonline/widgets/overlay_loader.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String code;
  const ResetPasswordScreen({
    super.key,
    required this.code,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isVerifyingCode = false;
  bool obscurePassword = true;

  bool? isFieldPhoneNumber;

  String countryCode = 'MW';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void changePassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (confirmPasswordController.text != passwordController.text) {
      BotToasts.showToast(message: "Passwords do not match", isError: true);
      return;
    }

    if (confirmPasswordController.text.isEmpty ||
        passwordController.text.isEmpty) {
      return;
    }

    setState(() {
      isVerifyingCode = true;
    });

    try {
      await AuthAPI().changePassword(
        token: widget.code,
        newPassword: passwordController.text.trim(),
      );

      BotToasts.showToast(message: "Password Changed", isError: false);
      Navigator.popUntil(context, (route) => route.isFirst);
      // Navigator.pushReplacement(
      //   context,
      //   CupertinoPageRoute(
      //     builder: (context) => const LoginScreen(),
      //   ),
      // );
      ProvidersInit.refreshProviders(context: context);
    } catch (e) {
      BotToasts.showToast(message: e.toString(), isError: true);
      debugPrint(e.toString());
      setState(() {
        isVerifyingCode = false;
      });
      return;
    }

    setState(() {
      isVerifyingCode = false;
    });
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
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            const SizedBox(height: 50),
                            const Text(
                              "Change Password",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildForms(),
                            const SizedBox(height: 20),
                            Button(
                              text: isVerifyingCode
                                  ? "Changing Password..."
                                  : "Change Password",
                              onTap: () {
                                changePassword();
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.07,
                            ),
                          ],
                        ),
                      ),
                      isVerifyingCode ? const OverlayLoader() : Container(),
                    ],
                  ),
                ),
              )
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
          const SizedBox(height: 10),
          TextFormField(
            controller: passwordController,
            obscureText: obscurePassword,
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
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Icon(
                    obscurePassword
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                    size: 20,
                  ),
                ),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: SvgPicture.asset(
                  "assets/svg/password.svg",
                  width: 10,
                  color: Colors.grey, // Assuming darkGrey is a Color variable
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: confirmPasswordController,
            // obscureText: obscurePassw,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            decoration: authInputDecoration.copyWith(
              hintText: "Confirm Password",
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: SvgPicture.asset(
                  "assets/svg/password.svg",
                  width: 10,
                  color: Colors.grey, // Assuming darkGrey is a Color variable
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
