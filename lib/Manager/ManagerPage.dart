import 'package:flutter/material.dart';
import 'package:chasier_cafe/Admin/ProfilePage.dart';
import 'package:chasier_cafe/Service/Manager/ShowUserChasier.dart';
import 'OrderHistoryPage.dart'; // Import halaman baru

class ManagerPage extends StatefulWidget {
  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  final ShowUserCashier showUserCashier = ShowUserCashier();
  List<Map<String, dynamic>> cashierData = [];
  String searchQuery = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchCashierData();
  }

  Future<void> fetchCashierData() async {
    try {
      final data = await showUserCashier.fetchCashierData();
      setState(() {
        cashierData = data;
      });
    } catch (e) {
      print('Failed to fetch cashier data: $e');
    }
  }

  List<Map<String, dynamic>> _filteredCashierData() {
    if (searchQuery.isEmpty) {
      return cashierData;
    }
    return cashierData
        .where((cashier) =>
            cashier['user_name']
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            cashier['username']
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
        .toList();
  }

  Widget _buildCashierCard(Map<String, dynamic> cashier) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.brown[300],
          child: Text(
            cashier['user_name'].substring(0, 2).toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        title: Text(
          cashier['user_name'],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Username: ${cashier['username']}',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              Text(
                'ID: ${cashier['user_id'].toString().padLeft(4, '0')}',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.brown[500]),
        onTap: () {
          // Navigasi ke halaman riwayat order saat card ditekan
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OrderHistoryPage(userId: cashier['user_id']),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 1:
        return ProfilePage();
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Daftar Karyawan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),
            Expanded(
              child: _filteredCashierData().isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _filteredCashierData().length,
                      itemBuilder: (context, index) {
                        return _buildCashierCard(_filteredCashierData()[index]);
                      },
                    ),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: _currentIndex == 0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: AppBar(
                  backgroundColor: Colors.brown[500],
                  automaticallyImplyLeading: false,
                  flexibleSpace: Padding(
                    padding:
                        const EdgeInsets.only(top: 40, left: 16, right: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari Karyawan',
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white),
                        filled: true,
                        fillColor: Colors.brown[100],
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                ),
              )
            : null,
        body: _buildBody(),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: Colors.brown[500],
          unselectedItemColor: Colors.brown[200],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
