import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String baseUrl = 'http://10.0.2.2/api/login.php';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Membuat Map untuk body request
      final Map<String, String> requestBody = {
        'email': email.trim(),
        'password': password.trim(),
      };

      // Debug print untuk memeriksa data yang akan dikirim
      print('Request body before encoding: $requestBody');
      final encodedBody = json.encode(requestBody);
      print('Encoded JSON: $encodedBody');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: encodedBody,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      // Parse response
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return decodedResponse;
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } catch (e) {
      print('Error during login: $e');
      return {
        'success': false,
        'message': 'Error during login: $e',
      };
    }
  }
}