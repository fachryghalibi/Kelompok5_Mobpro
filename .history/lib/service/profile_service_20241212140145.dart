// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> updateProfile(String email, String fullName, String phoneNumber) async {
//   final String apiUrl = 'http://10.0.2.2/api_tubes/update_profile.php';
//   try {
//     final response = await http.put(
//       Uri.parse(apiUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'email': email,
//         'full_name': fullName,
//         'phone_number': phoneNumber,
//       }),
//     );

//     if (response.statusCode == 200) {
//       // Simpan data ke SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('full_name', fullName);
//       await prefs.setString('phone_number', phoneNumber);
//     } else {
//       final error = jsonDecode(response.body)['error'] ?? 'Gagal memperbarui profil';
//       throw Exception(error);
//     }
//   } catch (e) {
//     throw Exception('Terjadi kesalahan: $e');
//   }
// }
