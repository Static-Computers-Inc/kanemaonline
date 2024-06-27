import 'package:flutter/material.dart';


class TestsScreen extends StatefulWidget {
  const TestsScreen({super.key});

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  TextEditingController controller = TextEditingController();
  final String _errorText = "";

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tests"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // GestureDetector(
            //     onTap: () {
            //       showCupertinoModalBottomSheet(
            //         topRadius: Radius.zero,
            //         context: context,
            //         builder: (context) => const MiniPlayerPopUp(),
            //       );
            //     },
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: white,
            //       ),
            //       child: const Text("Test 1"),
            //     )),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.purple,
                    ),
                  ),
                  // seekBar()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget seekBar() {

  // }
}
