import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<Map<String, dynamic>> registerUser(
    String fullName, String email, String password, String phoneNumber) async {
  final url = 'http://10.0.2.2/api_tubes/registration.php'; 
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'full_name': fullName,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
      }),
    );

    final data = json.decode(response.body);

    // Handle different status codes
    switch (response.statusCode) {
      case 200: // Successful registration
        return data;
      case 400: // Bad request (validation error)
        throw Exception(data['message'] ?? 'Validation error');
      case 409: // Conflict (email already exists)
        throw Exception('Email already registered');
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
