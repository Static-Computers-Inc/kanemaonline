import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanemaonline/api/auth_api.dart';
import 'package:kanemaonline/data/countries.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/constants/input_decorations.dart';
import 'package:kanemaonline/screens/auth/login.dart';
import 'package:kanemaonline/screens/auth/verify_account.dart';
import 'package:kanemaonline/widgets/button.dart';

class RegisterScreen extends StatefulWidget {
  final String code;
  const RegisterScreen({super.key, required this.code});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onSubmit() async {
    if (!formKey.currentState!.validate()) {
      return;
    } else {
      // Register account
      await AuthAPI().register(
        userid: '',
        password: passwordController.text.trim(),
        phonenumber: phoneNumberController.text.trim(),
        name: '',
        email: emailController.text.trim(),
      );
    }

    //
    try {} catch (err) {
      debugPrint(err.toString());
    }
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
                                controller: emailController,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: authInputDecoration.copyWith(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: SvgPicture.asset(
                                      "assets/svg/email.svg",
                                      width: 10,
                                      color: darkGrey,
                                    ),
                                  ),
                                  hintText: "Email Address",
                                ),
                              ),
                              const SizedBox(height: 10),
                              ////////////
                              TextFormField(
                                controller: phoneNumberController,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: authInputDecoration.copyWith(
                                  prefixIcon: SizedBox(
                                    width: 16,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                      ),
                                      child: Center(
                                        child: Text(
                                          countries.firstWhere((element) =>
                                              element['code'] ==
                                              widget.code)['flag'],
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                  hintText: "Phone Number",
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: authInputDecoration.copyWith(
                                  hintText: "Password",
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
                              ),
                              const SizedBox(height: 20),
                              const SizedBox(height: 20),
                              Button(text: "Register", onTap: () {}),
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        const VerifyAccountScreen()));
                          },
                          child: const Text("verify account screen"),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
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
