import 'dart:convert';
import 'package:http/http.dart' as http;

class AddMenu {
  final String apiUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/menu';
  final String token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWtrY2FmZS5zbWt0ZWxrb20tbWxnLnNjaC5pZC9hcGkvbG9naW4iLCJpYXQiOjE3Mjg0NDE3NjUsImV4cCI6MTc2NDcyOTc2NSwibmJmIjoxNzI4NDQxNzY1LCJqdGkiOiJNQkk1U0g3TGlqV1d3OFZRIiwic3ViIjo1NiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.9VLkSW4PPsNw0BqJ8FPzYKJ6eUaERr-wMxh-A2fx3sg';
  final String makerID = '22'; // Set Maker ID sesuai kebutuhan

  Future<bool> addMenu(String name, String type, String description, int price,
      String imagePath) async {
    try {
      // Membuat request body dengan data yang diperlukan
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['makerID'] =
          makerID; // Tambahkan MakerID ke dalam headers

      // Menambahkan field data
      request.fields['menu_name'] = name;
      request.fields['type'] =
          type.toLowerCase(); // pastikan format huruf kecil
      request.fields['menu_description'] = description;
      request.fields['price'] = price.toString();

      // Menambahkan file gambar jika ada
      if (imagePath.isNotEmpty) {
        var image =
            await http.MultipartFile.fromPath('menu_image_name', imagePath);
        request.files.add(image);
      }

      // Mengirim request
      var response = await request.send();

      // Mendapatkan response body
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseData.body);
        if (jsonResponse['status'] == 'success') {
          print('Menu added successfully: ${jsonResponse['data']}');
          return true; // Menu berhasil ditambahkan
        } else {
          print('Failed to add menu: ${jsonResponse['message']}');
        }
      } else {
        print('Error: ${responseData.body}');
      }
    } catch (e) {
      print('Exception caught: $e');
    }

    return false; // Jika gagal menambahkan menu
  }
}
