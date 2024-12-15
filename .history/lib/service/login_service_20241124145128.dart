import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService {
  // Ganti dengan URL API Anda
  final String baseUrl = 'http://10.0.2.2/api/login.php';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'email': email,
          'password': password,
        },
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Login berhasil',
          'full_name': data['full_name'], // Tambahkan full_name dari response API
          'email': data['email'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }
}