import 'dart:convert';
import 'package:http/http.dart' as http;

class EditProfileService {
  final String baseUrl;

  EditProfileService(this.baseUrl);

  Future<bool> updateProfile({
    required String email,
    required String fullName,
    required String phoneNumber,
  }) async {
    final url = Uri.parse('$baseUrl/update_profile');
    final response = await http.put(
      url,
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
      print('Failed to update profile: ${response.body}');
      return false;
    }
  }
}
