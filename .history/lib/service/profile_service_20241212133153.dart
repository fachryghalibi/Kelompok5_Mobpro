import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileService {
  final String _baseUrl = 'http://10.0.2.2/api_tubes/update_profile.php';

  Future<bool> updateProfile({
    required String email,
    required String fullName,
    required String phoneNumber,
  }) async {
    final url = Uri.parse(_baseUrl);
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
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('full_name', fullName);
      await prefs.setString('phone_number', phoneNumber);

      return true;
    } else {
      print('Failed to update profile: ${response.body}');
      return false;
    }
  }
}
