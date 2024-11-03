import 'dart:convert';
import 'package:chasier_cafe/Service/Admin/ShowUser.dart';
import 'package:http/http.dart' as http;

class UserSearchService {
  final String baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/user/search';
  final String makerID = '22';
  final String token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWtrY2FmZS5zbWt0ZWxrb20tbWxnLnNjaC5pZC9hcGkvbG9naW4iLCJpYXQiOjE3Mjg0NDE3NjUsImV4cCI6MTc2NDcyOTc2NSwibmJmIjoxNzI4NDQxNzY1LCJqdGkiOiJNQkk1U0g3TGlqV1d3OFZRIiwic3ViIjo1NiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.9VLkSW4PPsNw0BqJ8FPzYKJ6eUaERr-wMxh-A2fx3sg'; // Pastikan untuk mengganti ini dengan token yang valid

  Future<List<User>> searchUsers(String searchKey) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$searchKey?makerID=$makerID'),
      headers: {
        "makerID": makerID,
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List users = jsonResponse['data'];
      return users.map((user) => User.fromJson(user)).toList();
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to search users');
    }
  }
}
