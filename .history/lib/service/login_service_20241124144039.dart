import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String baseUrl = 'http://10.0.2.2/api/login.php';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Debug prints sebelum request
      print('\n=== LOGIN REQUEST START ===');
      print('Target URL: $baseUrl');
      
      // Prepare the request
      final uri = Uri.parse(baseUrl);
      final request = http.Request('POST', uri);
      
      // Set headers
      request.headers.addAll({
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      });
      
      // Set body
      request.bodyFields = {
        'email': email.trim(),
        'password': password.trim(),
      };
      
      // Debug request details
      print('Request Method: ${request.method}');
      print('Request Headers: ${request.headers}');
      print('Request Body Fields: ${request.bodyFields}');
      
      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      // Debug response
      print('\n=== LOGIN RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');
      print('=== END LOGIN RESPONSE ===\n');
      
      // Parse and return response
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Non-200 status code received');
        return {
          'success': false,
          'message': 'Server returned status ${response.statusCode}',
          'debug': response.body
        };
      }
    } catch (e, stackTrace) {
      print('\n=== LOGIN ERROR ===');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      print('=== END LOGIN ERROR ===\n');
      
      return {
        'success': false,
        'message': 'Error during login: $e',
      };
    }
  }
}