import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileService {
  final String _baseUrl = 'http://10.0.2.2/api_tubes/update_profile.php';

  Future<bool> updateProfile({
    required String email,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      final response = await http.put(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'full_name': fullName,
          'phone_number': phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Gagal memperbarui profil';
        throw Exception(error);
      }
    } catch (e) {
      rethrow;
    }
  }
}