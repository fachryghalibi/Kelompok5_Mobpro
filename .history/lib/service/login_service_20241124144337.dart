import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String baseUrl;
  
  LoginService({required this.baseUrl});

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Debug print
      print('Sending login request to: $baseUrl/login.php');
      print('Email: $email');
      
      // Encode body properly
      final encodedBody = json.encode({
        'email': email,
        'password': password,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: encodedBody,
      );

      // Debug prints
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'success': false,
          'message': 'HTTP Error: ${response.statusCode}',
          'body': response.body,
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }
}