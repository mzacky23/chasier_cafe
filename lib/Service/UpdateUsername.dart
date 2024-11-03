import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateUsernameService {
  static Future<Map<String, dynamic>?> updateUsername(
      int userId, String newUsername) async {
    final String url =
        'https://ukkcafe.smktelkom-mlg.sch.id/api/updateusername/$userId';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('token'); // Pastikan token sudah diambil dengan benar

    if (token == null) {
      return {
        'status': 'failed',
        'message': 'Token tidak ditemukan. Harap login ulang.'
      };
    }

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'makerID': '22', // Pastikan nilai ini benar
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': newUsername,
        }),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': 'failed',
          'message': 'Gagal memperbarui username: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'status': 'failed',
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }
}
