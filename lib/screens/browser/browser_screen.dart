// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserScreen extends StatefulWidget {
  final String url;
  final String title;
  const BrowserScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  ValueNotifier progressIndicator = ValueNotifier(0);

  late final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          //sets progress when loading a url/page
          progressIndicator.value = progress / 100;
          progressIndicator.notifyListeners();
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) async {
          //resets progress to zero
          progressIndicator.value = 0;
          progressIndicator.notifyListeners();
          debugPrint("page loaded");
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint("WebResourceError: ${error.description}");
        },
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(widget.url));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            progressIndicatorBar(),
            Expanded(child: WebViewWidget(controller: controller)),
          ],
        ),
      ),
    );
  }

  Widget progressIndicatorBar() {
    return ValueListenableBuilder(
      valueListenable: progressIndicator,
      builder: (context, value, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: MediaQuery.of(context).size.width * value,
          height: 1.85,
          color: Colors.white,
        );
      },
    );
  }
}
