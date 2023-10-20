import 'package:http/http.dart' as http;

const String baseUrl =
    // 'https://meatoz.hawkssolutions.com/basicapi/public/v1/';
    'https://meatoz.in/basicapi/public/v1/';

class ApiHelper {
  var client = http.Client();
  String offset ="0";

  Future<dynamic> post({required String endpoint, required Map body}) async {
    try {
      var url = Uri.parse(baseUrl + endpoint);

      var _headers = {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhcnlhYXMiLCJuYW1lIjoiSGF3a3MgU29sdXRpb25zIiwiYWRtaW4iOnRydWV9.BoaclKRc8ZpUbWFoQ0tv80RRncyXtRypI6jDVIJQOas',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      var response = await client.post(url, body: body, headers: _headers);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('HTTP request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in API request: $e');
      // Handle the error, you might want to log it, show a message to the user, etc.
      // For example, you can re-throw the exception to propagate it to the UI.
      throw e;
    }
  }

}