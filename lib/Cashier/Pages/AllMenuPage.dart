import 'package:chasier_cafe/Cashier/MakingOrderPage.dart';
import 'package:chasier_cafe/Service/Cashier/ShowMenuDrink.dart';
import 'package:chasier_cafe/Service/Cashier/ShowMenuFood.dart';
import 'package:flutter/material.dart';
import 'package:chasier_cafe/Service/Admin/ShowMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllMenuPage extends StatefulWidget {
  @override
  _AllMenuPageState createState() => _AllMenuPageState();
}

class _AllMenuPageState extends State<AllMenuPage> {
  String selectedCategory = 'Semua';
  Future<List<dynamic>>? _menus;
  Map<int, int> orderCount = {};
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchMenus();
  }

  void _fetchMenus() {
    setState(() {
      if (selectedCategory == 'Makanan') {
        _menus = ShowMenuFoodService().fetchFoodMenus();
      } else if (selectedCategory == 'Minuman') {
        _menus = ShowMenuDrinkService().fetchDrinkMenus();
      } else {
        _menus = MenuService().fetchMenus();
      }
    });
  }

  void _incrementOrder(int menuId, double price) {
    setState(() {
      orderCount[menuId] = (orderCount[menuId] ?? 0) + 1;
      totalPrice += price;
    });
  }

  void _decrementOrder(int menuId, double price) {
    setState(() {
      if (orderCount[menuId] != null && orderCount[menuId]! > 0) {
        orderCount[menuId] = orderCount[menuId]! - 1;
        totalPrice -= price;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _categoryButton('Semua'),
                  _categoryButton('Makanan'),
                  _categoryButton('Minuman'),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _menus,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Tidak ada data tersedia'));
                  } else {
                    List<dynamic> menus = snapshot.data!;
                    return ListView.builder(
                      itemCount: menus.length,
                      itemBuilder: (context, index) {
                        var menu = menus[index];
                        double price = menu.price.toDouble();
                        int count = orderCount[menu.id] ?? 0;
                        return _buildProductCard(
                          menu.name,
                          price,
                          count,
                          menu.imageUrl,
                          menu.type ?? 'Makanan',
                          menu.description,
                          menu.id,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.brown,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: Offset(3, 5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _checkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: StadiumBorder(),
              ),
              child: Text(
                'Checkout: Rp ${totalPrice.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _categoryButton(String text) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: selectedCategory == text ? Colors.white : Colors.black,
        backgroundColor:
            selectedCategory == text ? Colors.black : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () {
        setState(() {
          selectedCategory = text;
        });
        _fetchMenus();
      },
      child: Text(text),
    );
  }

  Widget _buildProductCard(String name, double price, int count,
      String imageUrl, String type, String description, int menuId) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Image.network(
          imageUrl,
          height: 80,
          width: 75,
          fit: BoxFit.cover,
        ),
        title: Text(
          name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: $type', style: TextStyle(fontSize: 12)),
            SizedBox(height: 5),
            Text(description,
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            SizedBox(height: 5),
            Text(
              'Rp ${price.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: () {
                _decrementOrder(menuId, price);
              },
            ),
            Text(
              '$count',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {
                _incrementOrder(menuId, price);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _checkout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendapatkan User ID')),
      );
      return;
    }

    if (totalPrice > 0) {
      List<Map<String, dynamic>> orders = [];

      _menus!.then((menus) {
        orderCount.forEach((id, quantity) {
          if (quantity > 0) {
            var menu = menus.firstWhere((menu) => menu.id == id);
            orders.add({
              'menu_id': menu.id,
              'name': menu.name,
              'price': menu.price,
              'quantity': quantity,
              'image': menu.imageUrl,
            });
          }
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MakingOrderPage(orderItems: orders, userId: userId),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak ada item yang dipesan')),
      );
    }
  }
}
