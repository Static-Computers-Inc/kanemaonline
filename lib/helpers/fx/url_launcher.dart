import 'package:url_launcher/url_launcher.dart';

class LaunchUrl {
  static launch(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView);
    } else {
      throw 'Could not launch $url';
    }
  }
}
