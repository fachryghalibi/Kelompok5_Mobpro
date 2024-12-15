// lib/service/login_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final url = 'http://10.0.2.2/api/login.php'; // URL API login
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}), // Pastikan body dalam format JSON
      );

      print("Response body: ${response.body}"); // Debugging: tampilkan response body

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data; // Mengembalikan hasil response dari server
      } else {
        return {
          'success': false,
          'message': 'Terjadi kesalahan pada server.',
        };
      }
    } catch (error) {
      return {
        'success': false,
        'message': 'Gagal terhubung ke server.',
      };
    }
  }
}
