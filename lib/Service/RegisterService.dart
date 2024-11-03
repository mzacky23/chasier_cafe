import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {
  Future<Map<String, dynamic>?> registerAct(
      Map<String, dynamic> request) async {
    final url = 'https://ukkcafe.smktelkom-mlg.sch.id/api/register';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"makerID": "22"},
        body: request,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': 'Registration failed. Please try again.'
        };
      }
    } catch (e) {
      print('Error: $e');
      return {
        'success': false,
        'message': 'Error occurred. Please check your connection.'
      };
    }
  }
}
