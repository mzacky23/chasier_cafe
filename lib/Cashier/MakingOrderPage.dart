import 'package:chasier_cafe/Cashier/PaymentPage.dart';
import 'package:chasier_cafe/Service/Cashier/OrderService.dart';
import 'package:flutter/material.dart';
import 'package:chasier_cafe/Service/Admin/ShowTable.dart';

class MakingOrderPage extends StatefulWidget {
  final List<Map<String, dynamic>> orderItems;
  final int userId;

  MakingOrderPage({required this.orderItems, required this.userId});

  @override
  _MakingOrderPageState createState() => _MakingOrderPageState();
}

class _MakingOrderPageState extends State<MakingOrderPage> {
  String customerName = '';
  TableData? selectedTable;
  List<TableData> tables = [];
  double totalPrice = 0; // Variabel instance

  @override
  void initState() {
    super.initState();
    // Hitung total harga saat inisialisasi
    totalPrice = widget.orderItems
        .fold(0, (sum, item) => sum + (item['price'] * item['quantity']));

    fetchTables().then((data) {
      setState(() {
        tables = data.where((table) => table.isAvailable).toList();
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat meja: $error')),
      );
    });
  }

  void placeOrder() async {
    try {
      if (selectedTable == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Silakan pilih meja')),
        );
        return;
      }

      List<Map<String, dynamic>> orderDetails = widget.orderItems.map((item) {
        return {
          'menu_id': item['menu_id'],
          'quantity': item['quantity'],
        };
      }).toList();

      final response = await OrderService.placeOrder(
        userId: widget.userId,
        tableId: selectedTable!.tableId,
        customerName: customerName,
        orderDetails: orderDetails,
      );

      if (response['status'] == 'success') {
        // Ambil orderId dengan validasi null menggunakan null-aware operator
        int? orderId = response['data']['order']['order_id'] as int?;

        if (orderId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentPage(
                totalPrice: totalPrice,
                orderId: orderId, // Kirim orderId ke halaman PaymentPage
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order ID tidak ditemukan')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat pesanan')),
        );
      }
    } catch (e) {
      print("Error: $e");
      if (e.toString().contains('Token tidak valid atau kedaluwarsa')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token tidak valid. Silakan login ulang.')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.brown,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 28,
          weight: 700,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Detail Pesanan
            Card(
              color: Colors.white,
              elevation: 0,
              margin: EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(0), // Menghilangkan sudut membulat
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Detail Pesanan",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Nama Pelanggan",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) => customerName = value,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<TableData>(
                      decoration: InputDecoration(
                        labelText: "Pilih Meja",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: tables.map((table) {
                        return DropdownMenuItem<TableData>(
                          value: table,
                          child: Text(table.tableNumber),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => selectedTable = value),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 0),

            // Bagian Daftar Pesanan
            Expanded(
              child: Card(
                color: Colors.white,
                elevation: 0,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(0), // Menghilangkan sudut membulat
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Daftar Pesanan",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: widget.orderItems.length,
                          itemBuilder: (context, index) {
                            var item = widget.orderItems[index];
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      item['image'],
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Rp ${item['price']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${item['quantity']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Pesanan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Rp $totalPrice',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: placeOrder,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.brown,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text(
                      "Bayar",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
