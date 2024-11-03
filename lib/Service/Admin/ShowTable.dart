import 'dart:convert';
import 'package:http/http.dart' as http;

class TableData {
  final int tableId;
  final String tableNumber;
  final bool isAvailable;

  TableData({
    required this.tableId,
    required this.tableNumber,
    required this.isAvailable,
  });

  factory TableData.fromJson(Map<String, dynamic> json) {
    return TableData(
      tableId: json['table_id'],
      tableNumber: json['table_number'],
      isAvailable: json['is_available'] == 'true',
    );
  }
}

Future<List<TableData>> fetchTables() async {
  const String apiUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/table';
  const String token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWtrY2FmZS5zbWt0ZWxrb20tbWxnLnNjaC5pZC9hcGkvbG9naW4iLCJpYXQiOjE3Mjg0NDE3NjUsImV4cCI6MTc2NDcyOTc2NSwibmJmIjoxNzI4NDQxNzY1LCJqdGkiOiJNQkk1U0g3TGlqV1d3OFZRIiwic3ViIjo1NiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.9VLkSW4PPsNw0BqJ8FPzYKJ6eUaERr-wMxh-A2fx3sg'; // Replace with your actual token
  const String makerID = '22'; // Replace with your makerID if needed

  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Bearer $token',
      'makerID': makerID, // Add makerID in the headers
    },
  );

  print("Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    List<dynamic> tablesJson = json.decode(response.body);
    return tablesJson
        .where((table) => table['maker_id'] == int.parse(makerID))
        .map((tableJson) => TableData.fromJson(tableJson))
        .toList();
  } else if (response.statusCode == 401) {
    throw Exception('Unauthorized: Invalid token or makerID');
  } else if (response.statusCode == 403) {
    throw Exception('Forbidden: Access denied');
  } else {
    throw Exception('Error ${response.statusCode}: Failed to load tables');
  }
}
