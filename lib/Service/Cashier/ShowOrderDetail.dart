import 'dart:convert';
import 'package:http/http.dart' as http;

class ShowDetailOrder {
  final String baseUrl =
      'https://ukkcafe.smktelkom-mlg.sch.id/api/orderdetail/';
  final String token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbG9jYWxob3N0L2NhZmVfdWtrL3B1YmxpYy9hcGkvbG9naW4iLCJpYXQiOjE3MjcxODkyMDcsImV4cCI6MTc2MzQ3NzIwNywibmJmIjoxNzI3MTg5MjA3LCJqdGkiOiJKbnEwdTgzcTVRYjB6eXNuIiwic3ViIjo0LCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.lf3Dwi6ov8VUaPI4MOdyabsCAnFUn3_RFYa_6Qg8WmM';
  final int makerID = 22;

  Future<Map<String, dynamic>> fetchOrderDetail(int orderId) async {
    final response = await http.get(
      Uri.parse('$baseUrl$orderId'),
      headers: {
        'Authorization': 'Bearer $token',
        'makerID': makerID.toString(),
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return data;
      }
    }
    throw Exception('Failed to load order details');
  }
}
