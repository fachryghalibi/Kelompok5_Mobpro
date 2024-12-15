import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2/api';  // Untuk Emulator Android

  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final url = '$_baseUrl/registration.php'; // URL endpoint registrasi
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        return {'success': false, 'message': 'Server error: ${response.statusCode}'};
      }
    } catch (error) {
      return {'success': false, 'message': 'Connection error: $error'};
    }
  }
}
