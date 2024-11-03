import 'dart:convert';
import 'package:http/http.dart' as http;

class DeleteMenu {
  final String token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWtrY2FmZS5zbWt0ZWxrb20tbWxnLnNjaC5pZC9hcGkvbG9naW4iLCJpYXQiOjE3Mjg0NDE3NjUsImV4cCI6MTc2NDcyOTc2NSwibmJmIjoxNzI4NDQxNzY1LCJqdGkiOiJNQkk1U0g3TGlqV1d3OFZRIiwic3ViIjo1NiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.9VLkSW4PPsNw0BqJ8FPzYKJ6eUaERr-wMxh-A2fx3sg';
  final String makerID = '22'; // Maker ID yang perlu disertakan di headers

  Future<bool> deleteMenu(int menuId) async {
    final String apiUrl =
        'https://ukkcafe.smktelkom-mlg.sch.id/api/menu/$menuId';

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'makerID': makerID, // Sertakan MakerID di headers
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          print('Menu deleted successfully');
          return true;
        } else {
          print('Failed to delete menu: ${jsonResponse['message']}');
        }
      } else {
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Exception caught: $e');
    }

    return false; // Jika gagal menghapus menu
  }
}
