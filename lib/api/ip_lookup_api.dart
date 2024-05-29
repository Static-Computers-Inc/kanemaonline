import "dart:convert";

import "package:http/http.dart" as http;

class IPLookUpAPI {
  final String iPREGISTRYAPIKEY = "gzckeqrbnc84wlk2";
  final String bASEURL = "https://api.ipregistry.co/";

  Future<Map<dynamic, dynamic>> getIPData() async {
    final url = Uri.parse('$bASEURL/?key=$iPREGISTRYAPIKEY');
    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = await jsonDecode(response.body) as Map<dynamic, dynamic>;
      return data;
    }

    return {};
  }
}
