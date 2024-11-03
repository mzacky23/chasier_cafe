import 'dart:convert';
import 'package:http/http.dart' as http;

class ShowMenuFoodService {
  static const String token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWtrY2FmZS5zbWt0ZWxrb20tbWxnLnNjaC5pZC9hcGkvbG9naW4iLCJpYXQiOjE3Mjg0NDE3NjUsImV4cCI6MTc2NDcyOTc2NSwibmJmIjoxNzI4NDQxNzY1LCJqdGkiOiJNQkk1U0g3TGlqV1d3OFZRIiwic3ViIjo1NiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.9VLkSW4PPsNw0BqJ8FPzYKJ6eUaERr-wMxh-A2fx3sg';

  Future<List<FoodMenu>> fetchFoodMenus() async {
    final response = await http.get(
      Uri.parse('https://ukkcafe.smktelkom-mlg.sch.id/api/menu/show/food'),
      headers: {
        'Authorization': 'Bearer $token',
        'makerID': '22',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];
      return data.map((item) => FoodMenu.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load food menus');
    }
  }
}

class FoodMenu {
  final int id;
  final String name;
  final String description;
  final int price;
  final String imageUrl;
  final String type; // Tambahkan type di sini

  FoodMenu({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.type, // Tambahkan type di sini
  });

  factory FoodMenu.fromJson(Map<String, dynamic> json) {
    return FoodMenu(
      id: json['menu_id'],
      name: json['menu_name'],
      description: json['menu_description'],
      price: json['price'],
      imageUrl:
          'https://ukkcafe.smktelkom-mlg.sch.id/' + json['menu_image_name'],
      type: json['type'], // Pastikan 'type' ada di data JSON
    );
  }
}
