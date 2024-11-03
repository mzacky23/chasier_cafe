import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateOrderStatus {
  final String _baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/order';

  Future<void> updateOrderStatus(int orderId) async {
    try {
      // Ambil token dari SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await http.put(
        Uri.parse('$_baseUrl/$orderId/status'), // Gunakan orderId di URL
        headers: {
          'makerID': '22',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': 'paid'}),
      );

      if (response.statusCode == 200) {
        print("Status order berhasil diperbarui ke 'Paid'");
      } else {
        print("Gagal memperbarui status order: ${response.body}");
        throw Exception('Gagal memperbarui status order');
      }
    } catch (e) {
      print("Error saat memperbarui status order: $e");
      throw e;
    }
  }
}
