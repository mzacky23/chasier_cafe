import 'package:chasier_cafe/Service/Cashier/ShowOrderDetail.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatefulWidget {
  final int orderId;

  OrderDetailPage({required this.orderId});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  Map<String, dynamic>? orderDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetail();
  }

  Future<void> _fetchOrderDetail() async {
    final showDetailOrder = ShowDetailOrder();

    try {
      print('Fetching details for Order ID: ${widget.orderId}'); // Debugging

      final detail = await showDetailOrder.fetchOrderDetail(widget.orderId);
      print('Detail Order: $detail'); // Debugging

      setState(() {
        orderDetail = detail;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat detail order')),
      );
    }
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Selesai':
        color = Colors.green;
        break;
      case 'Proses':
        color = Colors.orange;
        break;
      case 'Batal':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(
        status,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Order'),
        backgroundColor: Colors.brown,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : orderDetail == null
              ? Center(child: Text('Detail order tidak ditemukan'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ID Order: ${widget.orderId}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          _buildStatusChip(
                              orderDetail?['status'] ?? 'Tidak diketahui'),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Total Harga: Rp ${orderDetail?['total_price'] ?? 0}",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 16),
                      orderDetail!['data'].isEmpty
                          ? Text(
                              'Tidak ada item dalam pesanan ini.',
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[700],
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: orderDetail!['data'].length,
                                itemBuilder: (context, index) {
                                  final item = orderDetail!['data'][index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                item['menu_name']
                                                            ?.toString()
                                                            .isNotEmpty ==
                                                        true
                                                    ? item['menu_name']
                                                    : 'Produk tidak diketahui',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.brown[700],
                                                ),
                                              ),
                                              Text(
                                                "Rp ${item['price'] ?? 0}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.green[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "Jumlah: ${item['quantity'] ?? 0}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          Divider(thickness: 1),
                                          Text(
                                            "Tipe: ${item['type'] ?? 'Tidak diketahui'}",
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
    );
  }
}
