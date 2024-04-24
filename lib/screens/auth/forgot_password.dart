import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/widgets/button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

enum Mode { email, phone }

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  Mode mode = Mode.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Image.asset('assets/images/logo-color.png'),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            const Text(
              "Forgot Password?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text("Don't worry! it happens."),
            const Text(
              "Please enter the email or phone number associated with your account and we'll reset your password.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextFormField(),
            const SizedBox(height: 20),
            Wrap(
              children: [
                Text(
                  mode == Mode.email
                      ? "Reset using phone number?"
                      : "Reset using email?",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    mode = mode == Mode.email ? Mode.phone : Mode.email;
                    setState(() {});
                  },
                  child: Text(
                    "Switch",
                    style: TextStyle(
                      color: red,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: red,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Button(
              text: "Reset Password",
              onTap: () {},
            ),
            Expanded(child: Container()),
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
