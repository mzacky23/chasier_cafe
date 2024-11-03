import 'dart:convert';
import 'package:http/http.dart' as http;

class AddUserService {
  final String baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/register';
  final String makerID = '22'; // Ganti ini dengan ID pembuat yang sesuai

  Future<bool> addUser(
      String userName, String role, String username, String password) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'makerID': makerID, // Tambahkan header makerID
      },
      body: jsonEncode({
        'user_name': userName,
        'role': role,
        'username': username,
        'password': password,
      }),
    );

    // Print status code and response body for debugging
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // Ubah status kode di sini untuk mencakup 200
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true; // User added successfully
    } else {
      return false; // Failed to add user
    }
  }
}
