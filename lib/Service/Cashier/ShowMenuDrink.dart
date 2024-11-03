import 'dart:convert';
import 'package:http/http.dart' as http;

class DrinkMenu {
  final int id;
  final String name;
  final String type;
  final String description;
  final int price;
  final String imageUrl;

  DrinkMenu({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory DrinkMenu.fromJson(Map<String, dynamic> json) {
    return DrinkMenu(
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

class ShowMenuDrinkService {
  Future<List<DrinkMenu>> fetchDrinkMenus() async {
    final response = await http.get(
      Uri.parse('https://ukkcafe.smktelkom-mlg.sch.id/api/menu/show/drink'),
      headers: {
        'makerID': '22',
        'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWtrY2FmZS5zbWt0ZWxrb20tbWxnLnNjaC5pZC9hcGkvbG9naW4iLCJpYXQiOjE3Mjg0NDE3NjUsImV4cCI6MTc2NDcyOTc2NSwibmJmIjoxNzI4NDQxNzY1LCJqdGkiOiJNQkk1U0g3TGlqV1d3OFZRIiwic3ViIjo1NiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.9VLkSW4PPsNw0BqJ8FPzYKJ6eUaERr-wMxh-A2fx3sg',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<DrinkMenu> drinks = (data['data'] as List)
          .map((drinkJson) => DrinkMenu.fromJson(drinkJson))
          .toList();
      return drinks;
    } else {
      throw Exception('Failed to load drinks: ${response.reasonPhrase}');
    }
  }
}
