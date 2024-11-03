import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String _profileUrl =
      'https://ukkcafe.smktelkom-mlg.sch.id/api/user-profile';

  static Future<dynamic> fetchUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print('Token tidak ditemukan');
        return null;
      }

      final response = await http.get(
        Uri.parse(_profileUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'makerID': '22', // Ganti dengan nilai yang sesuai
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Gagal memuat profil: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }
}
