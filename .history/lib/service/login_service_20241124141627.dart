import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final url = 'http://10.0.2.2/api/login.php';
      
      // Buat Map untuk body request
      final Map<String, dynamic> bodyMap = {
        'email': email,
        'password': password,
      };

      // Debug: Print request yang akan dikirim
      print('Sending request with body: ${json.encode(bodyMap)}');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Tambahkan header untuk menghindari masalah CORS
          'Access-Control-Allow-Origin': '*',
        },
        // Encode body request menggunakan json.encode
        body: json.encode(bodyMap),
      );

      // Debug: Print response yang diterima
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Parse response
      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = json.decode(response.body);
          return responseData;
        } catch (e) {
          print('Error parsing response: $e');
          return {
            'success': false,
            'message': 'Error parsing response: $e'
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Network error: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }
}