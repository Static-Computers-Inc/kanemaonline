// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanemaonline/api/auth_api.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/screens/auth/account_verified_screen.dart';
import 'package:kanemaonline/services/websocket_service.dart';
import 'package:kanemaonline/widgets/bot_toasts.dart';
import 'package:kanemaonline/widgets/button.dart';
import 'package:kanemaonline/widgets/overlay_loader.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerifyAccountScreen extends StatefulWidget {
  final String phoneNumber;
  final String userId;
  const VerifyAccountScreen({
    super.key,
    required this.phoneNumber,
    required this.userId,
  });

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  String _code = "";
  String signature = "ywgemoumiX9";

  bool verifyingCode = false;

  @override
  void initState() {
    super.initState();
    WebSocketService().connectAndListen(widget.phoneNumber);
    SmsAutoFill().listenForCode();
    otpTimerCounter();
  }

  int timeLeft = 60;
  bool _isDisposed = false;
  Timer? otpTimerCountDown;

  void otpTimerCounter() {
    if (otpTimerCountDown != null) {
      otpTimerCountDown!.cancel();
    }

    setState(() {
      timeLeft = 60;
    });

    const oneSec = Duration(seconds: 1);
    otpTimerCountDown = Timer.periodic(oneSec, (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          _code = "";
        }
      });
    });
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    _isDisposed = true;
    otpTimerCountDown?.cancel();
    super.dispose();
  }

  void verifyOTP(dynamic otp) async {
    debugPrint("verifying otp");
    setState(() {
      verifyingCode = true;
    });

    try {
      await AuthAPI().verifyOTP(code: otp);
      Navigator.popUntil(
        context,
        (route) => route.isFirst,
      );
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const AccountVerifiedScreen(),
        ),
      );

      setState(() {
        verifyingCode = false;
      });
    } catch (err) {
      setState(() {
        verifyingCode = false;
        _code = "";
      });

      BotToasts.showToast(
        message: err.toString(),
        isError: true,
      );
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
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              "Verify Account",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "We have sent the verification code to your phone number ${widget.phoneNumber}",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: darkAccent),
                            ),
                            const SizedBox(height: 20),
                            PinFieldAutoFill(
                              codeLength: 4,
                              decoration: UnderlineDecoration(
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                colorBuilder: FixedColorBuilder(
                                  Colors.red.withOpacity(0.5),
                                ),
                              ),
                              currentCode: "",
                              onCodeSubmitted: (code) {
                                verifyOTP(code);
                              },
                              onCodeChanged: (code) {
                                if (code!.length == 4) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  verifyOTP(code);
                                }

                                _code = code;
                              },
                            ),
                            const SizedBox(height: 20),
                            buildTimeLeft(),
                            const SizedBox(height: 20),
                            Button(
                              text: verifyingCode ? "Verifying..." : "Submit",
                              onTap: () => verifyOTP(_code),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                          ],
                        ),
                      ),
                      verifyingCode ? const OverlayLoader() : Container(),
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

  Widget buildTimeLeft() {
    if (timeLeft > 0) {
      return Text(
        "Resend in ${timeLeft.toString().padLeft(2, "0")} seconds",
        style: TextStyle(
          color: black,
          fontWeight: FontWeight.w700,
        ),
      );
    } else {
      return Wrap(
        children: [
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Didn't receive the code?",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              try {
                await AuthAPI().resendOTP(
                  userId: widget.userId,
                );
                otpTimerCounter(); // This will restart the timer on resend
              } catch (err) {
                BotToasts.showToast(message: err.toString(), isError: true);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Resend",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: red,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
