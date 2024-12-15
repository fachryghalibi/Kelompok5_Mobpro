import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String baseUrl = 'http://10.0.2.2/api/login.php';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Buat map untuk body
      final Map<String, String> body = {
        'email': email.trim(),
        'password': password.trim(),
      };

      // Debug prints
      print('Attempting to send request to: $baseUrl');
      print('Request body: $body');

      // Kirim request dengan form-urlencoded
      final response = await http.post(
        Uri.parse(baseUrl),
        body: body,  // Kirim sebagai form data
        headers: {
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return decodedResponse;
      } else {
        print('Server error: ${response.statusCode}');
        print('Error body: ${response.body}');
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error during login: $e');
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }
}