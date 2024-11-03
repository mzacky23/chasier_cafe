import 'package:chasier_cafe/Service/Cashier/SerachMenu.dart';
import 'package:flutter/material.dart';

class SearchMenuPage extends StatefulWidget {
  final String searchKey;

  SearchMenuPage({required this.searchKey});

  @override
  _SearchMenuPageState createState() => _SearchMenuPageState();
}

class _SearchMenuPageState extends State<SearchMenuPage> {
  late Future<List<dynamic>> _searchResults;
  Map<int, int> orderCount = {};
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _searchResults = SearchMenuService().searchMenus(widget.searchKey);
  }

  void _incrementOrder(int menuId, double price) {
    setState(() {
      orderCount[menuId] = (orderCount[menuId] ?? 0) + 1;
      totalPrice += price;
    });
  }

  void _decrementOrder(int menuId, double price) {
    setState(() {
      if (orderCount[menuId]! > 0) {
        orderCount[menuId] = orderCount[menuId]! - 1;
        totalPrice -= price;
      }
    });
  }

  void _checkout() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          totalPrice > 0
              ? 'Checkout sukses dengan total harga Rp ${totalPrice.toStringAsFixed(0)}'
              : 'Tidak ada item yang dipesan',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Pencarian'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _searchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Tidak ada hasil ditemukan'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var menu = snapshot.data![index];
                      double price = menu['price'].toDouble();
                      int count = orderCount[menu['menu_id']] ?? 0;
                      return _buildProductCard(menu, count, price);
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _checkout,
              child: Text('Checkout: Rp ${totalPrice.toStringAsFixed(0)}'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic menu, int count, double price) {
    String imageUrl =
        'https://ukkcafe.smktelkom-mlg.sch.id/${menu['menu_image_name']}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Image.network(
              imageUrl,
              height: 80,
              width: 75,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(menu['menu_name'] ?? 'Nama tidak tersedia',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(menu['type'] ?? 'Tipe tidak tersedia'),
                  Text(menu['menu_description'] ?? 'Deskripsi tidak tersedia'),
                  Text('Rp ${price.toStringAsFixed(0)}'),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => _decrementOrder(menu['menu_id'], price),
                ),
                Text('$count'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _incrementOrder(menu['menu_id'], price),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
