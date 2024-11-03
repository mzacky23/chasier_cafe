import 'dart:convert';
import 'package:http/http.dart' as http;

class DeleteTableService {
  final String apiUrl = "https://ukkcafe.smktelkom-mlg.sch.id/api/table/";

  Future<bool> deleteTable(String tableId) async {
    final response = await http.delete(
      Uri.parse('$apiUrl$tableId'),
      headers: {
        'makerID': '22',
        'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWtrY2FmZS5zbWt0ZWxrb20tbWxnLnNjaC5pZC9hcGkvbG9naW4iLCJpYXQiOjE3Mjg0NDE3NjUsImV4cCI6MTc2NDcyOTc2NSwibmJmIjoxNzI4NDQxNzY1LCJqdGkiOiJNQkk1U0g3TGlqV1d3OFZRIiwic3ViIjo1NiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.9VLkSW4PPsNw0BqJ8FPzYKJ6eUaERr-wMxh-A2fx3sg',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['status'] == 'success';
    } else {
      return false;
    }
  }
}
