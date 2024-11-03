import 'package:chasier_cafe/Cashier/CashierPage.dart';
import 'package:chasier_cafe/Service/Cashier/ShowOrderDetail.dart';
import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  final int orderId;
  final double paidAmount;
  final double change;

  NotePage({
    required this.orderId,
    required this.paidAmount,
    required this.change,
  });

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late Future<Map<String, dynamic>> _orderData;
  final ShowDetailOrder _apiService = ShowDetailOrder();

  @override
  void initState() {
    super.initState();
    _orderData = _apiService.fetchOrderDetail(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.brown.shade300, Colors.brown.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _orderData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('Data not available'));
              }

              final data = snapshot.data!['data'];
              final totalPrice = snapshot.data!['total_price'];
              final userName = data[0]['user_name']; // Ganti di sini
              final orderDate = data[0]['order_date'];
              final List<Widget> orderItems = data.map<Widget>((item) {
                return _orderItem(
                  item['menu_name'],
                  item['quantity'],
                  item['price'],
                  item['quantity'] * item['price'],
                );
              }).toList();

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 80),
                        SizedBox(height: 10),
                        Text(
                          'Transaksi Berhasil',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Colors.brown, width: 1),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/images/Logo1.png',
                                        height: 70,
                                      ),
                                      SizedBox(height: 0),
                                      Text(
                                        'Wikusama Cafe',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12),
                                Divider(thickness: 1),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      orderDate,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      userName, // Tampilkan user_name
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Divider(thickness: 1),
                                SizedBox(height: 8),
                                ...orderItems,
                                Divider(thickness: 1),
                                _totalRow('Total Harga', totalPrice),
                                _totalRow('Tunai', widget.paidAmount),
                                _totalRow('Kembalian', widget.change),
                                SizedBox(height: 20),
                                Divider(thickness: 1),
                                Center(
                                  child: Text(
                                    'Terimakasih Sudah Memesan :)',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _actionButton(context, 'Cetak', Icons.print),
                            _actionButton(context, 'Home', Icons.home),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _orderItem(String item, int qty, int price, int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$item x$qty', style: TextStyle(fontSize: 16)),
          Text('Rp $total', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _totalRow(String label, num amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Rp ${amount.toDouble().toStringAsFixed(0)}',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, String label, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        if (label == 'Home') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CashierPage()),
            (route) => false,
          );
        } else if (label == 'Cetak') {
          _showCustomNotification(context);
        }
      },
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  void _showCustomNotification(BuildContext context) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.1,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.brown,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Berhasil Dicetak',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 1), () {
      overlayEntry.remove();
    });
  }
}
