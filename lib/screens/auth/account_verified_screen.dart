import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/screens/auth/login.dart';
import 'package:kanemaonline/widgets/button.dart';
import 'package:lottie/lottie.dart';

class AccountVerifiedScreen extends StatefulWidget {
  const AccountVerifiedScreen({super.key});

  @override
  State<AccountVerifiedScreen> createState() => _AccountVerifiedScreenState();
}

class _AccountVerifiedScreenState extends State<AccountVerifiedScreen> {
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
                        Center(
                          child: LottieBuilder.asset(
                            "assets/lottie/success.json",
                            repeat: false,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Account Verified",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: green,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Your account has been verified. You can now login.",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        Button(
                          onTap: () {
                            Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            );
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          text: "Login",
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
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
