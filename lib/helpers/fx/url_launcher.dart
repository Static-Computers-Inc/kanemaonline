import 'package:url_launcher/url_launcher.dart';

class LaunchUrlHelper {
  static launch(String url, {Function? onReturn}) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      var result = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.inAppWebView,
        webViewConfiguration: const WebViewConfiguration(),
      );

      if (onReturn != null) onReturn(result);
    } else {
      throw 'Could not launch $url';
    }
  }
}
