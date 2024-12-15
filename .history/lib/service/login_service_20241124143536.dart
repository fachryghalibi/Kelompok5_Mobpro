import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String baseUrl = 'http://10.0.2.2/api/login.php';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Debug pre-request
      print('=== LOGIN REQUEST DEBUG ===');
      print('Email: $email');
      print('Password: [HIDDEN]');
      
      // Prepare request
      final url = Uri.parse(baseUrl);
      final formData = {
        'email': email.trim(),
        'password': password.trim(),
      };
      
      print('URL: $url');
      print('Form Data: $formData');
      
      // Make POST request
      final response = await http.post(
        url,
        // Penting: Content-Type harus application/x-www-form-urlencoded
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        // Encode body sebagai form URL encoded
        body: formData,
        encoding: Encoding.getByName('utf-8'),
      ).timeout(Duration(seconds: 10)); // Tambah timeout untuk debugging
      
      print('=== LOGIN RESPONSE DEBUG ===');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body: ${response.body}');
      print('Request Method: ${response.request?.method}');
      
      // Parse response
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Server returned ${response.statusCode}',
          'debug': response.body
        };
      }
    } catch (e, stackTrace) {
      print('=== LOGIN ERROR DEBUG ===');
      print('Error: $e');
      print('Stack Trace: $stackTrace');
      
      return {
        'success': false,
        'message': 'Error during login: $e'
      };
    }
  }
}