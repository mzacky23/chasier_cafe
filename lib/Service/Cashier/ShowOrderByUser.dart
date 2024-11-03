import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShowOrderByUser {
  final String _url = 'https://ukkcafe.smktelkom-mlg.sch.id/api/order';

  Future<List<dynamic>?> fetchOrderHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');
      String? token = prefs.getString('token');

      if (userId == null || token == null) {
        print("User ID atau token tidak tersedia");
        return null;
      }

      final response = await http.get(
        Uri.parse('$_url/$userId'),
        headers: {
          "makerID": "22",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data['data'];
        } else {
          print("Gagal mengambil data: ${data['message']}");
          return null;
        }
      } else {
        print("Error: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("Error saat mengambil data riwayat pesanan: $e");
      return null;
    }
  }
}
