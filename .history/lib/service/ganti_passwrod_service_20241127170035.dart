import 'dart:convert';
import 'package:http/http.dart' as http;

class ChangePasswordService {
  final String baseUrl;

  ChangePasswordService({required this.baseUrl});

  Future<Map<String, dynamic>> changePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('$baseUrl/ganti_password.php');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data; // Mengembalikan respons dalam bentuk Map
      } else {
        return {
          'status': 'error',
          'message': 'Gagal menghubungi server. Status code: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Terjadi kesalahan saat menghubungi server: $e'
      };
    }
  }
}
