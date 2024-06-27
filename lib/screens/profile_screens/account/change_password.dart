import 'package:flutter/material.dart';
import 'package:kanemaonline/api/auth_api.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/constants/input_decorations.dart';
import 'package:kanemaonline/providers/user_info_provider.dart';
import 'package:kanemaonline/widgets/activity_loading_widget.dart';
import 'package:kanemaonline/widgets/bot_toasts.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPassword = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  bool isFieldPhoneNumber = false;

  String countryCode = 'MW';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: isLoading
          ? const CustomIndicatorWidget()
          : Consumer<UserInfoProvider>(builder: (context, value, _) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: oldPasswordController,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: authInputDecoration.copyWith(
                          hintText: "Old Password",
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: newPassword,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: authInputDecoration.copyWith(
                          hintText: "New Password",
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          isLoading = true;
                          setState(() {});

                          try {
                            await AuthAPI().changePasswordLoggedIn(
                              newPassword: newPassword.text.trim(),
                              oldPassword: oldPasswordController.text.trim(),
                            );
                          } catch (err) {
                            BotToasts.showToast(
                              message: err.toString(),
                              isError: true,
                            );
                          }

                          isLoading = false;
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: white,
                          ),
                          child: const Center(
                            child: Text(
                              "Change Password",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                      // value.userData['message'][0]['phone'] != null
                      //     ? ListTile(
                      //         onTap: () async {
                      //           try {
                      //             await AuthAPI().forgotPassword(
                      //               userId: value.userData['message'][0]
                      //                   ['phone'],
                      //             );
                      //             Navigator.push(
                      //               context,
                      //               CupertinoPageRoute(
                      //                 builder: (context) => VerifyPasswordOTP(
                      //                     credential: value.userData['message']
                      //                         [0]['phone']),
                      //               ),
                      //             );
                      //           } catch (err) {
                      //             BotToasts.showText(message: err.toString());
                      //           }
                      //         },
                      //         title: Text(
                      //             "Use ${value.userData['message'][0]['phone']}"),
                      //         subtitle: const Text(
                      //             "Change password using phone number"),
                      //         trailing: const CupertinoListTileChevron(),
                      //       )
                      //     : Container(),
                      // value.userData['message'][0]['email'] != null
                      //     ? ListTile(
                      //         onTap: () async {
                      //           try {
                      //             await AuthAPI().forgotPassword(
                      //               userId: value.userData['message'][0]
                      //                   ['email'],
                      //             );
                      //             Navigator.push(
                      //               context,
                      //               CupertinoPageRoute(
                      //                 builder: (context) => VerifyPasswordOTP(
                      //                     credential: value.userData['message']
                      //                         [0]['email']),
                      //               ),
                      //             );
                      //           } catch (err) {
                      //             BotToasts.showText(message: err.toString());
                      //           }
                      //         },
                      //         title: Text(
                      //             "Use ${value.userData['message'][0]['email'] ?? "Email"}"),
                      //         subtitle:
                      //             const Text("Change password using email"),
                      //         trailing: const CupertinoListTileChevron(),
                      //       )
                      //     : Container(),
                    ],
                  ),
                ),
              );
            }),
    );
  }
}
