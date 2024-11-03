import 'dart:convert';
import 'package:http/http.dart' as http;

class MenuService {
  static const String token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWtrY2FmZS5zbWt0ZWxrb20tbWxnLnNjaC5pZC9hcGkvbG9naW4iLCJpYXQiOjE3Mjg0NDE3NjUsImV4cCI6MTc2NDcyOTc2NSwibmJmIjoxNzI4NDQxNzY1LCJqdGkiOiJNQkk1U0g3TGlqV1d3OFZRIiwic3ViIjo1NiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.9VLkSW4PPsNw0BqJ8FPzYKJ6eUaERr-wMxh-A2fx3sg';

  Future<List<Menu>> fetchMenus({String? category}) async {
    final response = await http.get(
      Uri.parse('https://ukkcafe.smktelkom-mlg.sch.id/api/menu'),
      headers: {
        'Authorization': 'Bearer $token',
        'makerID': '22',
      },
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      List<Menu> menus = data.map((menu) => Menu.fromJson(menu)).toList();

      // Jika ada kategori yang dipilih, lakukan filter di sini
      if (category != null && category != 'Semua') {
        menus = menus.where((menu) => menu.type == category).toList();
      }

      return menus;
    } else {
      throw Exception('Failed to load menu');
    }
  }
}

class Menu {
  final int id;
  final String name;
  final String type;
  final String description;
  final int price;
  final String imageUrl;

  Menu({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['menu_id'],
      name: json['menu_name'],
      type: json['type'],
      description: json['menu_description'],
      price: json['price'],
      imageUrl:
          'https://ukkcafe.smktelkom-mlg.sch.id/' + json['menu_image_name'],
    );
  }
}
