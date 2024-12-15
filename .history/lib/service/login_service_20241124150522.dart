import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService {
  final String baseUrl = 'http://10.0.2.2/api';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Debug print
      print('Attempting login with email: $email');
      print('Request method: POST');
      print('Request URL: $baseUrl/login.php');
      
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'email': email,
          'password': password,
        },
      );

      // Debug prints
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Response headers: ${response.headers}');

      final data = json.decode(response.body);

      // Check untuk method not allowed
      if (data['message'] == 'Method not allowed') {
        print('ERROR: Server menerima request sebagai ${data['debug']?['method']} padahal seharusnya POST');
        return {
          'success': false,
          'message': 'Kesalahan konfigurasi server. Harap hubungi administrator.',
        };
      }

      if (response.statusCode == 200 && data['success'] == true) {
        // Sesuaikan dengan struktur JSON dari PHP
        return {
          'success': true,
          'message': data['message'],
          'full_name': data['data']['fullName'],
          'email': data['data']['email'],
          'id': data['data']['id'],
          'created_at': data['data']['createdAt']
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login gagal: ${response.statusCode}',
          'debug': data['debug'] ?? {}
        };
      }
    } catch (e, stackTrace) {
      print('Login error: $e');
      print('Stack trace: $stackTrace');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }
}