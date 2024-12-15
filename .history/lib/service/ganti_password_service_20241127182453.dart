import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GantiPassword {
  Future<Map<String, dynamic>> changePassword(
    int userId, String oldPassword, String newPassword) async {
    final url = 'http://10.0.2.2/api_tubes/ganti_password.php'; // Pastikan URL API benar

    if (oldPassword.isEmpty || newPassword.isEmpty) {
      throw Exception('Password lama dan baru tidak boleh kosong');
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,           // Mengirim user_id
          'old_password': oldPassword, // Mengirim old_password
          'new_password': newPassword, // Mengirim new_password
        }),
      );

      if (response.statusCode == 200) {
        // Berhasil
        return json.decode(response.body); // Mengembalikan respon JSON
      } else {
        // Menangani respons dengan status error
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Terjadi kesalahan');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on FormatException {
      throw Exception('Format data tidak valid');
    } catch (e) {
      throw Exception('Kesalahan: ${e.toString()}');
    }
  }
}
