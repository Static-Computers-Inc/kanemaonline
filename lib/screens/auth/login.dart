import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/constants/input_decorations.dart';
import 'package:kanemaonline/helpers/fx/providers_init.dart';
import 'package:kanemaonline/screens/screens.dart';
import 'package:kanemaonline/api/auth_api.dart';
import 'package:kanemaonline/widgets/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoginIn = false;
  bool obscurePassword = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void _login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }

    setState(() {
      isLoginIn = true;
    });

    try {
      await AuthAPI().login(
        userid: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const RootApp(),
        ),
      );
      ProvidersInit.refreshProviders(context: context);
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoginIn = false;
      });
      return;
    }

    setState(() {
      isLoginIn = false;
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
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        const Text(
                          "Login to Your Account",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildForms(),
                        const SizedBox(height: 20),

                        // forgot password
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const ForgotPassword(),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Button(
                          text: isLoginIn ? "Logging in..." : "Login",
                          onTap: () {
                            _login();
                          },
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          children: [
                            const Text(
                              "Don't have an account?",
                            ),
                            const SizedBox(width: 3),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const ChooseCountry(),
                                  ),
                                );
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: red,
                                ),
                              ),
                            )
                          ],
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

  Widget _buildForms() {
    return Form(
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
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: SvgPicture.asset(
                  "assets/svg/email.svg",
                  width: 10,
                  color: Colors.grey, // Assuming darkGrey is a Color variable
                ),
              ),
              hintText: "Email / Phone Number",
            ),
            validator: (value) {
              String pattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
              var regExp = RegExp(pattern);
              if (!regExp.hasMatch(value!)) {
                return "Email is not in a valid format";
              }
              return null;
            },
          ),
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
        ],
      ),
    );
  }
}
