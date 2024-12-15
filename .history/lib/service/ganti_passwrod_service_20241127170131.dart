import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<Map<String, dynamic>> changePassword(
    int userId, String oldPassword, String newPassword) async {
  final url = 'http://10.0.2.2/api_tubes/ganti_password.php'; 
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': userId,
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
    );

    final data = json.decode(response.body);

    // Handle different status codes
    switch (response.statusCode) {
      case 200: // Successful password change
        return data;
      case 400: // Bad request (validation error)
        throw Exception(data['message'] ?? 'Validation error');
      case 401: // Unauthorized (incorrect old password)
        throw Exception('Incorrect old password');
      case 500: // Server error
        throw Exception('Server error: ${data['message'] ?? 'Unknown error'}');
      default:
        throw Exception('Unexpected error occurred');
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}
}
