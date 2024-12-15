import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // URL dasar untuk API
  static const String _baseUrl = 'http://10.0.2.2/api'; // Ganti dengan alamat server Anda jika perlu

  // Fungsi untuk registrasi
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final url = '$_baseUrl/registration.php'; // URL endpoint registrasi
    try {
      // Mengirim permintaan POST ke API
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'full_name': fullName,
          'email': email,
          'password': password,
        }),
      );

      // Memeriksa status code respons
      if (response.statusCode == 200) {
        // Jika respons status 200, kembalikan hasil decoding JSON
        return json.decode(response.body);
      } else {
        // Jika ada masalah dengan server
        return {'success': false, 'message': 'Server error: ${response.statusCode}'};
      }
    } catch (error) {
      // Tangani error koneksi atau masalah lainnya
      return {'success': false, 'message': 'Connection error: $error'};
    }
  }
}
