import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/constants/input_decorations.dart';
import 'package:kanemaonline/providers/user_info_provider.dart';
import 'package:kanemaonline/screens/profile_screens/account/account_control_screen.dart';
import 'package:kanemaonline/screens/profile_screens/account/change_password.dart';
import 'package:kanemaonline/screens/profile_screens/account/edit_phonenumber_email.dart';
import 'package:kanemaonline/screens/profile_screens/account/edit_profile_screen.dart';
import 'package:kanemaonline/screens/profile_screens/account/update_phonenumber.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool disableFields = false;

  onUpdateProfile() async {
    try {} catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Consumer<UserInfoProvider>(builder: (context, value, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: white.withOpacity(0.75),
                      size: 14,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Click '→' or '+' to update or add your info.",
                      style: TextStyle(
                        color: white.withOpacity(0.55),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  "Email",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: white,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const EditPhonenumberEmail(),
                      ),
                    );
                  },
                  child: TextFormField(
                    // controller: emailController,
                    enabled: false,
                    initialValue: value.userData['message'][0]['email'],
                    style: TextStyle(
                      color: white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: authInputDecoration.copyWith(
                      hintText: "Email",
                      fillColor: darkerAccent,
                      suffixIcon: value.userData['message'][0]['email'] != null
                          ? Icon(
                              Icons.arrow_forward,
                              color: white.withOpacity(0.65),
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: white,
                                  size: 17,
                                ),
                              ),
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(
                          color: white,
                          width: 2.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Phone Number",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: white,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const UpdatePhonenumberScreen(),
                      ),
                    );
                  },
                  child: TextFormField(
                    enabled: false,
                    initialValue: value.userData['message'][0]['phone'],
                    style: TextStyle(
                      color: white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: authInputDecoration.copyWith(
                      hintText: "Phone Number",
                      fillColor: darkerAccent,
                      suffixIcon: value.userData['message'][0]['phone'] != null
                          ? Icon(
                              Icons.arrow_forward,
                              color: white.withOpacity(0.65),
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Center(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: white,
                                      size: 17,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(
                          color: white,
                          width: 2.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Username",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: white,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  enabled: false,
                  initialValue: value.userData['message'][0]['name'],
                  style: TextStyle(
                    color: white.withOpacity(0.65),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: authInputDecoration.copyWith(
                    hintText: "Username",
                    fillColor: darkerAccent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(
                        color: white,
                        width: 2.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Password",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: white,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                  child: TextFormField(
                    enabled: false,
                    initialValue: "password",
                    style: TextStyle(color: white, fontSize: 20, height: 2),
                    obscureText: true,
                    obscuringCharacter: "*",
                    decoration: authInputDecoration.copyWith(
                      hintText: "Email",
                      fillColor: darkerAccent,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  const ChangePasswordScreen(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.arrow_forward,
                          color: white.withOpacity(0.65),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(
                          color: white,
                          width: 2.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                Container(
                  width: double.infinity,
                  height: 0.55,
                  decoration: BoxDecoration(
                    color: white.withOpacity(
                      0.45,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const AccountControlScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Account Control >",
                        style: TextStyle(
                          color: white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return Bounceable(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const EditProfileScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: lightGrey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(width: 2, color: darkAccent),
        ),
        child: Center(
            child: Text(
          "Edit",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: white,
            fontSize: 15,
          ),
        )),
      ),
    );
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
      // border: OutlinedIn,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      labelStyle: TextStyle(
        color: white,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      // hintText: "Search",
      hintStyle: TextStyle(
        color: white,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
