import 'dart:convert';
import 'package:http/http.dart' as http;

class AddTableService {
  final String apiUrl = "https://ukkcafe.smktelkom-mlg.sch.id/api/table";
  final String token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWtrY2FmZS5zbWt0ZWxrb20tbWxnLnNjaC5pZC9hcGkvbG9naW4iLCJpYXQiOjE3Mjg0NDE3NjUsImV4cCI6MTc2NDcyOTc2NSwibmJmIjoxNzI4NDQxNzY1LCJqdGkiOiJNQkk1U0g3TGlqV1d3OFZRIiwic3ViIjo1NiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.9VLkSW4PPsNw0BqJ8FPzYKJ6eUaERr-wMxh-A2fx3sg";

  // Fungsi untuk menambah meja melalui API
  Future<bool> addTable(String tableNumber) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'makerID': '22', // Tambahkan header makerID
        },
        body: jsonEncode({
          "table_number": tableNumber,
          "is_available": "true",
          "maker_id": 22,
        }),
      );

      print("Response body: ${response.body}"); // Tambahkan log ini

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success'; // Pastikan ini
      } else {
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
