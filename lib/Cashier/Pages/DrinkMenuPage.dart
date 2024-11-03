import 'package:flutter/material.dart';
import 'package:chasier_cafe/Service/Cashier/ShowMenuDrink.dart'; // Pastikan path ini benar

class DrinkMenuPage extends StatefulWidget {
  @override
  _DrinkMenuPageState createState() => _DrinkMenuPageState();
}

class _DrinkMenuPageState extends State<DrinkMenuPage> {
  late Future<List<DrinkMenu>> _drinkMenus;

  @override
  void initState() {
    super.initState();
    _drinkMenus = ShowMenuDrinkService().fetchDrinkMenus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minuman'),
      ),
      body: FutureBuilder<List<DrinkMenu>>(
        future: _drinkMenus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Drink Data Available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final drink = snapshot.data![index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      drink.imageUrl,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(drink.name),
                    subtitle: Text('Rp ${drink.price}'),
                    trailing: IconButton(
                      icon: Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        // Implementasi untuk menambahkan ke keranjang nanti
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
