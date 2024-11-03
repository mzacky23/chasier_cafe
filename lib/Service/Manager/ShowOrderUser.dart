import 'dart:convert';
import 'package:http/http.dart' as http;

class ShowOrderUser {
  final int userId;

  ShowOrderUser(this.userId);

  Future<List<dynamic>?> fetchOrderHistory(String token) async {
    final response = await http.get(
      Uri.parse('https://ukkcafe.smktelkom-mlg.sch.id/api/order/${userId}'),
      headers: {
        'Authorization': 'Bearer $token',
        'makerID': '22', // Tambahkan header makerID
      },
    );

    if (response.statusCode == 200) {
      print(
          'Response data: ${response.body}'); // Tambahkan log ini untuk melihat data respons
      return json.decode(response.body)['data'];
    } else {
      print(
          'Error: ${response.statusCode} - ${response.body}'); // Tambahkan log ini untuk melihat error
      throw Exception('Failed to load order history');
    }
  }
}
