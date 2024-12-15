import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<Map<String, dynamic>> registerUser(
      String fullName, String email, String password) async {
    final url = 'http://10.0.2.2/api/registration.php'; // Update with actual API URL
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'full_name': fullName,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }
}
