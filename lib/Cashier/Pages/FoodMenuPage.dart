import 'package:chasier_cafe/Service/Cashier/ShowMenuFood.dart';
import 'package:flutter/material.dart';

class FoodMenuPage extends StatefulWidget {
  @override
  _FoodMenuPageState createState() => _FoodMenuPageState();
}

class _FoodMenuPageState extends State<FoodMenuPage> {
  late Future<List<FoodMenu>> _foodMenus;

  @override
  void initState() {
    super.initState();
    _foodMenus = ShowMenuFoodService().fetchFoodMenus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Makanan'),
      ),
      body: FutureBuilder<List<FoodMenu>>(
        future: _foodMenus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Food Data Available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final food = snapshot.data![index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      food.imageUrl,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(food.name),
                    subtitle: Text('Rp ${food.price}'),
                    trailing: IconButton(
                      icon: Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        // Implementasi tambahkan ke keranjang nanti
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
