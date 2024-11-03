import 'dart:convert';
import 'package:http/http.dart' as http;

class UpdateMenu {
  Future<bool> updateMenu(
    int menuId,
    String name,
    String type,
    String description,
    int price,
    String imagePath,
  ) async {
    final url = 'https://ukkcafe.smktelkom-mlg.sch.id/api/menu/$menuId';

    final headers = {
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWtrY2FmZS5zbWt0ZWxrb20tbWxnLnNjaC5pZC9hcGkvbG9naW4iLCJpYXQiOjE3Mjg0NDE3NjUsImV4cCI6MTc2NDcyOTc2NSwibmJmIjoxNzI4NDQxNzY1LCJqdGkiOiJNQkk1U0g3TGlqV1d3OFZRIiwic3ViIjo1NiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.9VLkSW4PPsNw0BqJ8FPzYKJ6eUaERr-wMxh-A2fx3sg',
      'MakerID': '22',
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'menu_name': name,
      'type': type.toLowerCase(), // Pastikan tipe dikirim dalam huruf kecil
      'menu_description': description,
      'price': price,
      // Jika gambar tidak digunakan, abaikan atau kirim path gambar jika perlu
    });

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return true; // Update berhasil
      } else {
        print('Failed to update menu: ${response.statusCode}');
        print('Response Body: ${response.body}');
        return false; // Gagal
      }
    } catch (e) {
      print('Error: $e');
      return false; // Error
    }
  }
}
