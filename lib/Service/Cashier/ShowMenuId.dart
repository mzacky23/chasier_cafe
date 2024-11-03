import 'dart:convert';
import 'package:http/http.dart' as http;

class GetMenuDetailService {
  final String baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/menu';

  Future<Map<String, dynamic>?> fetchMenuDetail(
      String menuId, String token) async {
    final url = Uri.parse('$baseUrl/$menuId');
    try {
      final response = await http.get(
        url,
        headers: {
          'makerID': '22',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Gagal mengambil data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
