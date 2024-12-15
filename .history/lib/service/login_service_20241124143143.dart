import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String baseUrl = 'http://10.0.2.2/api/login.php';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Siapkan data
      var urlEncoded = Uri.parse(baseUrl);
      var formData = {
        'email': email.trim(),
        'password': password.trim(),
      };

      // Debug log
      print('Sending request to: $baseUrl');
      print('With data: $formData');

      // Kirim request dengan multipart
      var request = http.MultipartRequest('POST', urlEncoded);
      
      // Tambahkan fields
      request.fields['email'] = email.trim();
      request.fields['password'] = password.trim();

      // Kirim request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Parse response
      var responseData = json.decode(response.body);
      return responseData;

    } catch (e) {
      print('Error during login: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
}