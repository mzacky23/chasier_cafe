import 'dart:convert';
import 'package:http/http.dart' as http;

class UpdateUserService {
  final String baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/user';
  final String makerID = '22';
  final String token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWtrY2FmZS5zbWt0ZWxrb20tbWxnLnNjaC5pZC9hcGkvbG9naW4iLCJpYXQiOjE3Mjg0NDE3NjUsImV4cCI6MTc2NDcyOTc2NSwibmJmIjoxNzI4NDQxNzY1LCJqdGkiOiJNQkk1U0g3TGlqV1d3OFZRIiwic3ViIjo1NiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.9VLkSW4PPsNw0BqJ8FPzYKJ6eUaERr-wMxh-A2fx3sg';

  Future<bool> updateUser(
      int userId, String userName, String role, String username) async {
    final url = Uri.parse('$baseUrl/$userId');
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "makerID": makerID,
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'user_name': userName,
        'role': role,
        'username': username,
      }),
    );

    if (response.statusCode == 200) {
      return true; // Berhasil update
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return false; // Gagal update
    }
  }
}
