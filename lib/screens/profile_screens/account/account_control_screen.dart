// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanemaonline/api/auth_api.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/providers/auth_provider.dart';
import 'package:kanemaonline/services/auth_service.dart';
import 'package:kanemaonline/widgets/overlay_loader.dart';
import 'package:kanemaonline/wrapper.dart';
import 'package:provider/provider.dart';

class AccountControlScreen extends StatefulWidget {
  const AccountControlScreen({super.key});

  @override
  State<AccountControlScreen> createState() => _AccountControlScreenState();
}

class _AccountControlScreenState extends State<AccountControlScreen> {
  bool isLoading = false;

  void deleteAccount() async {
    try {
      isLoading = true;
      setState(() {});
      await AuthAPI().deleteAccount(
        userId: Provider.of<AuthProvider>(context, listen: false).userid,
      );
      isLoading = false;
      setState(() {});
      await AuthService.signout(context: context);
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const Wrapper(),
        ),
      );
    } catch (err) {
      isLoading = false;
      setState(() {});
    }
  }

  void deactivateAccount() async {
    try {
      isLoading = true;
      setState(() {});
      await AuthAPI().deactivateAccount(
          userId: Provider.of<AuthProvider>(context, listen: false).userid);
      isLoading = false;
      setState(() {});
      await AuthService.signout(context: context);
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const Wrapper(),
        ),
      );
    } catch (err) {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 45,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Deactivating or Deleting your Kanema Online account",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "you can temporarily deactivate this account, or permanently delete your account.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Deactivate your account",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Deactivating your account is temporary, you'll lose active subscriptions. But you can reactivate your account by loging in anytime.",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          buildActionButton(
                            title: "Deactivate account",
                            onTap: () => deactivateAccount(),
                            color: Colors.yellow.shade700,
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.width * 0.1),
                          const Text(
                            "Delete your account",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Deleting your account is permanent. when you delete your account, you wont be able to retrive the content or your information, all other data will aslo be deleted ",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          buildActionButton(
                            title: "Delete account",
                            onTap: () => deleteAccount(),
                            color: red,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            isLoading ? const OverlayLoader() : Container()
          ],
        ),
      ),
    );
  }

  Widget buildActionButton(
      {required String title, required Function onTap, required Color color}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: white,
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
