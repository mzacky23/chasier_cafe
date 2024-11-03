import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchMenuService {
  final String baseUrl =
      'https://ukkcafe.smktelkom-mlg.sch.id/api/menu/search/';

  Future<List<dynamic>> searchMenus(String searchKey) async {
    final response = await http.get(
      Uri.parse('$baseUrl$searchKey'), // Ubah URL untuk menyertakan searchKey
      headers: {
        'makerID': '22',
        'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWtrY2FmZS5zbWt0ZWxrb20tbWxnLnNjaC5pZC9hcGkvbG9naW4iLCJpYXQiOjE3Mjg0NDE3NjUsImV4cCI6MTc2NDcyOTc2NSwibmJmIjoxNzI4NDQxNzY1LCJqdGkiOiJNQkk1U0g3TGlqV1d3OFZRIiwic3ViIjo1NiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.9VLkSW4PPsNw0BqJ8FPzYKJ6eUaERr-wMxh-A2fx3sg',
      },
    );

    if (response.statusCode == 200) {
      print(response.body); // Untuk debugging
      final jsonResponse = json.decode(response.body);
      return jsonResponse['data']; // Kembalikan data dari respons
    } else {
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to load search results');
    }
  }
}
