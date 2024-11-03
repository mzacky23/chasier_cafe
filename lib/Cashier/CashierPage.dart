import 'package:chasier_cafe/Service/Cashier/SerachMenu.dart';
import 'package:flutter/material.dart';
import 'package:chasier_cafe/Admin/ProfilePage.dart';
import 'package:chasier_cafe/Cashier/HistoryPage.dart';
import 'package:chasier_cafe/Cashier/Pages/AllMenuPage.dart';

class CashierPage extends StatefulWidget {
  @override
  _CashierPageState createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  int _currentIndex = 0;
  String searchKey = '';
  late Future<List<dynamic>> _searchResults;

  final List<Widget> _pages = [
    AllMenuPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  void _searchMenu(String key) {
    setState(() {
      searchKey = key;
      _searchResults = searchKey.isEmpty
          ? Future.value([])
          : SearchMenuService().searchMenus(searchKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: _currentIndex == 0
            ? AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                title: Row(
                  children: [
                    Image.asset(
                      'assets/images/Logo.png',
                      height: 40,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        onChanged: _searchMenu,
                        decoration: InputDecoration(
                          hintText: 'Cari Menu',
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color:
                                  Colors.grey, // Warna border saat tidak fokus
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.brown, // Warna border saat fokus
                              width: 2,
                            ),
                          ),
                          fillColor: Colors.white, // Warna latar belakang putih
                          filled:
                              true, // Aktifkan fill agar warna latar diterapkan
                        ),
                      ),
                    )
                  ],
                ),
              )
            : null,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _currentIndex == 0
                    ? searchKey.isEmpty
                        ? AllMenuPage()
                        : FutureBuilder<List<dynamic>>(
                            future: _searchResults,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                  child: Text('Tidak ada hasil ditemukan'),
                                );
                              } else {
                                List<dynamic> results = snapshot.data!;
                                return ListView.builder(
                                  itemCount: results.length,
                                  itemBuilder: (context, index) {
                                    var menu = results[index];
                                    return ListTile(
                                      leading: Image.network(
                                          'https://ukkcafe.smktelkom-mlg.sch.id/${menu['menu_image_name']}',
                                          height: 80,
                                          width: 75, errorBuilder:
                                              (context, error, stackTrace) {
                                        return const Icon(Icons.error);
                                      }), // Menampilkan gambar menu
                                      title: Text(menu['menu_name'] ??
                                          'Nama tidak tersedia'), // Nama menu
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(menu['type'] ??
                                              'Tipe tidak tersedia'), // Tipe menu
                                          Text(menu['menu_description'] ??
                                              'Deskripsi tidak tersedia'), // Deskripsi menu
                                          Text(
                                              'Rp ${menu['price']?.toString() ?? '0'}'), // Harga menu
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          )
                    : _pages[_currentIndex],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              searchKey = '';
            });
          },
          backgroundColor: Colors.brown[700],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
