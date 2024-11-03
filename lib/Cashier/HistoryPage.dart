import 'package:chasier_cafe/Cashier/OrderDetailPage.dart';
import 'package:chasier_cafe/Service/Cashier/ShowOrderByUser.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic>? orderHistory;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrderHistory();
  }

  Future<void> _fetchOrderHistory() async {
    final showOrderByUser = ShowOrderByUser();
    final history = await showOrderByUser.fetchOrderHistory();
    setState(() {
      orderHistory = history;
      isLoading = false;
    });
  }

  String _formatDate(String dateString) {
    final DateTime date = DateTime.parse(dateString);
    return DateFormat('dd MMMM yyyy')
        .format(date); // Format lengkap: hari, bulan, dan tahun
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Transaksi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.brown,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : orderHistory == null || orderHistory!.isEmpty
              ? Center(child: Text('Tidak ada riwayat transaksi'))
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: orderHistory!.length,
                  itemBuilder: (context, index) {
                    final order = orderHistory![index];
                    final currentOrderDate = _formatDate(order['order_date']);
                    final previousOrderDate = index > 0
                        ? _formatDate(orderHistory![index - 1]['order_date'])
                        : '';

                    // Menampilkan pembatas jika tanggal penuh berbeda
                    bool showDateDivider =
                        currentOrderDate != previousOrderDate;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showDateDivider)
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Center(
                              child: Text(
                                currentOrderDate,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        Card(
                          elevation: 1,
                          margin: EdgeInsets.symmetric(vertical: 6),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailPage(
                                      orderId: order['order_id']),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.brown,
                                    width: 1), // Tambahkan border di sini
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text(
                                        "Nama Pelanggan: ${order['customer_name']}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.brown[700],
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 4),
                                          Text(
                                              "Tanggal: ${order['order_date']}"),
                                          Text("Status: ${order['status']}"),
                                          Text(
                                              "Nomor Meja: ${order['table_number']}"),
                                        ],
                                      ),
                                      leading: Icon(
                                        Icons.receipt_long,
                                        color: Colors.brown,
                                        size: 40,
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, bottom: 8),
                                      child: Text(
                                        "ID Order: ${order['order_id']}",
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}
