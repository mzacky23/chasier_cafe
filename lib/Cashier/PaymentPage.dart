import 'package:chasier_cafe/Cashier/NotePage.dart';
import 'package:chasier_cafe/Service/Cashier/UpdateOrderStatus.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final double totalPrice;
  final int orderId; // Tambahkan orderId

  PaymentPage({required this.totalPrice, required this.orderId});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  double enteredAmount = 0.0;
  final TextEditingController _controller = TextEditingController();

  void _handlePayment() async {
    if (enteredAmount >= widget.totalPrice) {
      double change = enteredAmount - widget.totalPrice;

      // Panggil API untuk update status order menjadi "Paid"
      try {
        await UpdateOrderStatus().updateOrderStatus(widget.orderId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Pembayaran berhasil! Kembalian: Rp ${change.toStringAsFixed(0)}')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotePage(
              orderId: widget.orderId,
              paidAmount: enteredAmount, // Uang yang dibayar
              change: change, // Kembalian
            ),
          ),
        );

// Pindah ke NotePage setelah pembayaran berhasil
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui status order: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nominal pembayaran tidak cukup')),
      );
    }
  }

  void _showPaymentDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.35, // Awal muncul 35% layar
          minChildSize: 0.2, // Ukuran minimal saat ditarik turun
          maxChildSize: 0.8, // Ukuran maksimal saat ditarik naik
          expand: false,
          builder: (context, scrollController) {
            return SafeArea(
              // Tambahkan SafeArea untuk menjaga area aman
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 16, right: 16, bottom: 16),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          'Rincian Pembayaran',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(thickness: 1),
                      SizedBox(height: 8),
                      _paymentDetailRow('Total Harga', widget.totalPrice),
                      _paymentDetailRow('Tunai', enteredAmount),
                      _paymentDetailRow(
                          'Kembalian', enteredAmount - widget.totalPrice),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _paymentDetailRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Text(
          'Rp ${amount.toStringAsFixed(0)}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildAmountCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nominal Uang Tunai',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 20, // Ukuran teks lebih besar
                fontWeight: FontWeight.bold, // Membuat teks tebal
              ),
              decoration: InputDecoration(
                prefixText: 'Rp ',
                prefixStyle: TextStyle(
                  fontSize: 20, // Ukuran teks prefix lebih besar
                  fontWeight: FontWeight.bold, // Teks prefix tebal
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 20), // Padding untuk memperbesar ukuran field
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  enteredAmount = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _quickAmountButton(10000),
                  SizedBox(width: 10),
                  _quickAmountButton(30000),
                  SizedBox(width: 10),
                  _quickAmountButton(50000),
                  SizedBox(width: 10),
                  _quickAmountButton(100000),
                  SizedBox(width: 10),
                  _quickAmountButton(150000),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          'Bayar',
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
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Harga',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rp ${widget.totalPrice.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 0),
            buildAmountCard(),
            Spacer(),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 6,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: _showPaymentDetails,
                        child: Row(
                          children: [
                            Text(
                              'Total Pembayaran',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.arrow_drop_up,
                              color: Colors.brown,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Rp ${enteredAmount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _handlePayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                    ),
                    child: Text(
                      'Bayar',
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
            SizedBox(height: 0),
          ],
        ),
      ),
    );
  }

  Widget _quickAmountButton(double amount) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          enteredAmount = amount;
          _controller.text = amount.toStringAsFixed(0);
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white, // Warna background putih
        side: BorderSide(color: Colors.grey), // Border berwarna abu-abu
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Border radius
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
      child: Text(
        'Rp ${amount.toStringAsFixed(0)}',
        style: TextStyle(
          fontSize: 16,
          color: Colors.brown,
          fontWeight: FontWeight.bold,
        ), // Teks warna coklat
      ),
    );
  }
}
