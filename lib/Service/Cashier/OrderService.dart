import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  static Future<Map<String, dynamic>> placeOrder({
    required int userId,
    required int tableId,
    required String customerName,
    required List<Map<String, dynamic>> orderDetails,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    const String apiUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/order';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "makerID": "22",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'user_id': userId,
          'table_id': tableId,
          'customer_name': customerName,
          'detail': orderDetails, // <-- Perbaikan di sini
        }),
      );

      print("Token: $token");
      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Response body: ${response.body}");
        if (response.statusCode == 401) {
          await prefs.remove('token');
          throw Exception('Unauthorized: Token tidak valid atau kedaluwarsa');
        } else {
          throw Exception('Gagal membuat pesanan: ${response.reasonPhrase}');
        }
      }
    } catch (e) {
      print("Error saat membuat pesanan: $e");
      throw Exception("Terjadi kesalahan jaringan: $e");
    }
  }
}
