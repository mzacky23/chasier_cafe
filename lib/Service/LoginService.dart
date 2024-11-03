import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  final String _url = 'https://ukkcafe.smktelkom-mlg.sch.id/api/login';

  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          "makerID": "22",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          await saveUserData(
              responseData['access_token'], responseData['user']);
        }

        if (responseData['user'] != null &&
            responseData['user']['user_id'] != null) {
          await saveUserData(
              responseData['access_token'], responseData['user']);
          return responseData;
        } else {
          return {'success': false, 'message': 'user_id tidak ditemukan'};
        }
      } else {
        return {
          'success': false,
          'message': 'Failed to login: ${response.reasonPhrase}',
        };
      }
    } catch (e) {
      print("Error saat login: $e");
      return {'success': false, 'message': 'Error occurred: $e'};
    }
  }

  Future<void> saveUserData(String token, Map<String, dynamic> user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print("Token Disimpan: $token");

    if (user['user_id'] != null) {
      await prefs.setInt('user_id', user['user_id']);
      print("User ID Disimpan: ${user['user_id']}");
    } else {
      print("User ID is null");
    }

    await prefs.setString('user_data', jsonEncode(user));
  }
}
