import 'package:flutter/material.dart';
import 'package:chasier_cafe/Service/Manager/ShowOrderUser.dart';
import 'package:intl/intl.dart';

class OrderHistoryPage extends StatefulWidget {
  final int userId;

  OrderHistoryPage({required this.userId});

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late ShowOrderUser showOrderUser;
  List<dynamic> orderHistory = [];
  List<dynamic> filteredOrderHistory = [];
  bool isLoading = true;

  // Variables for filtering
  String? selectedMonth;
  String? selectedYear;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    showOrderUser = ShowOrderUser(widget.userId);
    fetchOrderHistory();
  }

  Future<void> fetchOrderHistory() async {
    String token =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbG9jYWxob3N0L2NhZmVfdWtrL3B1YmxpYy9hcGkvbG9naW4iLCJpYXQiOjE3MjcxODkyMDcsImV4cCI6MTc2MzQ3NzIwNywibmJmIjoxNzI3MTg5MjA3LCJqdGkiOiJKbnEwdTgzcTVRYjB6eXNuIiwic3ViIjo0LCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.lf3Dwi6ov8VUaPI4MOdyabsCAnFUn3_RFYa_6Qg8WmM"; // Replace with your token
    var history = await showOrderUser.fetchOrderHistory(token);
    if (history != null) {
      setState(() {
        orderHistory = history;
        filteredOrderHistory = history;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatDate(String dateString) {
    final DateTime date = DateTime.parse(dateString);
    return DateFormat('dd MMMM yyyy').format(date);
  }

  void _filterOrders() {
    setState(() {
      filteredOrderHistory = orderHistory.where((order) {
        final orderDate = DateTime.parse(order['order_date']);
        bool matches = true;

        // Filter by date
        if (selectedDate != null) {
          matches &= orderDate.day == selectedDate!.day &&
              orderDate.month == selectedDate!.month &&
              orderDate.year == selectedDate!.year;
        }

        // Filter by month
        if (selectedMonth != null) {
          matches &= orderDate.month == int.parse(selectedMonth!);
        }

        // Filter by year
        if (selectedYear != null) {
          matches &= orderDate.year == int.parse(selectedYear!);
        }

        return matches;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Pesanan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.brown,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Filter by Date
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              selectedDate = date;
                            });
                            _filterOrders();
                          }
                        },
                        child: Text(selectedDate != null
                            ? DateFormat('dd-MM-yyyy').format(selectedDate!)
                            : 'Pilih Tanggal'),
                      ),

                      // Filter by Month
                      DropdownButton<String>(
                        value: selectedMonth,
                        hint: Text('Pilih Bulan'),
                        items: List.generate(12, (index) {
                          String month = (index + 1).toString().padLeft(2, '0');
                          return DropdownMenuItem(
                            value: month,
                            child: Text(DateFormat.MMMM().format(
                              DateTime(0, index + 1),
                            )),
                          );
                        }),
                        onChanged: (value) {
                          setState(() {
                            selectedMonth = value;
                          });
                          _filterOrders();
                        },
                      ),

                      // Filter by Year
                      DropdownButton<String>(
                        value: selectedYear,
                        hint: Text('Pilih Tahun'),
                        items: List.generate(5, (index) {
                          String year =
                              (DateTime.now().year - index).toString();
                          return DropdownMenuItem(
                            value: year,
                            child: Text(year),
                          );
                        }),
                        onChanged: (value) {
                          setState(() {
                            selectedYear = value;
                          });
                          _filterOrders();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: filteredOrderHistory.isEmpty
                      ? Center(child: Text('Tidak ada riwayat pesanan'))
                      : ListView.builder(
                          padding: EdgeInsets.all(8),
                          itemCount: filteredOrderHistory.length,
                          itemBuilder: (context, index) {
                            final order = filteredOrderHistory[index];
                            final currentOrderDate =
                                _formatDate(order['order_date']);
                            final previousOrderDate = index > 0
                                ? _formatDate(filteredOrderHistory[index - 1]
                                    ['order_date'])
                                : '';

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
                                      border: Border.all(
                                          color: Colors.black, width: 1),
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
                                      // Navigasi ke detail pesanan jika diperlukan
                                      // Navigator.push(...);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                Text(
                                                    "Status: ${order['status']}"),
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
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
