import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/user';
  final String makerID = '22';
  final String token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWtrY2FmZS5zbWt0ZWxrb20tbWxnLnNjaC5pZC9hcGkvbG9naW4iLCJpYXQiOjE3Mjg0NDE3NjUsImV4cCI6MTc2NDcyOTc2NSwibmJmIjoxNzI4NDQxNzY1LCJqdGkiOiJNQkk1U0g3TGlqV1d3OFZRIiwic3ViIjo1NiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.9VLkSW4PPsNw0BqJ8FPzYKJ6eUaERr-wMxh-A2fx3sg'; // Pastikan untuk mengganti ini dengan token yang valid

  Future<List<User>> fetchUsers() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "makerID": makerID,
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Metode ini tidak perlu, jika Anda sudah menggunakan UserSearchService
  Future<List<User>> searchUsers(String searchKey) async {
    throw UnimplementedError();
  }
}

class User {
  final int userId;
  final String userName;
  final String role;
  final String username;

  User({
    required this.userId,
    required this.userName,
    required this.role,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      userName: json['user_name'],
      role: json['role'],
      username: json['username'],
    );
  }
}
