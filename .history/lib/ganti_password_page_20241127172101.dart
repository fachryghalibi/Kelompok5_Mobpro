import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasDigit = false;
  bool _hasSpecialChar = false;
  bool _isLoading = false;

  // URL API untuk mengganti kata sandi
  final String apiUrl = 'https://yourapi.com/change_password.php';

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_updatePasswordStrength);
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength() {
    setState(() {
      _hasMinLength = _newPasswordController.text.length >= 8;
      _hasUppercase = _newPasswordController.text.contains(RegExp(r'[A-Z]'));
      _hasLowercase = _newPasswordController.text.contains(RegExp(r'[a-z]'));
      _hasDigit = _newPasswordController.text.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = _newPasswordController.text.contains(RegExp(r'[!@#\$&*~]'));
    });
  }

  Future<void> _handlePasswordChange() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Kirim request API untuk mengganti kata sandi
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'old_password': _oldPasswordController.text,
            'new_password': _newPasswordController.text,
          }),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'success') {
            // Tampilkan notifikasi sukses
            _showSuccessDialog();
          } else {
            // Tampilkan pesan error dari server
            _showErrorDialog(data['message']);
          }
        } else {
          // Jika status code tidak 200
          _showErrorDialog('Terjadi kesalahan saat menghubungi server');
        }
      } catch (e) {
        // Jika terjadi error dalam koneksi
        _showErrorDialog('Terjadi kesalahan saat mengubah kata sandi');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Berhasil"),
          content: const Text("Kata sandi Anda berhasil diperbarui."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Gagal"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ganti Kata Sandi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _oldPasswordController,
                obscureText: _obscureOldPassword,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi Lama',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureOldPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureOldPassword = !_obscureOldPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kata sandi lama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi Baru',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kata sandi baru tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Kata Sandi Baru',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi kata sandi tidak boleh kosong';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Konfirmasi kata sandi tidak cocok';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: _newPasswordController,
                builder: (context, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Minimal 8 karakter', style: TextStyle(color: _hasMinLength ? Colors.green : Colors.red)),
                      Text('Mengandung huruf besar', style: TextStyle(color: _hasUppercase ? Colors.green : Colors.red)),
                      Text('Mengandung huruf kecil', style: TextStyle(color: _hasLowercase ? Colors.green : Colors.red)),
                      Text('Mengandung angka', style: TextStyle(color: _hasDigit ? Colors.green : Colors.red)),
                      Text('Mengandung karakter khusus', style: TextStyle(color: _hasSpecialChar ? Colors.green : Colors.red)),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _handlePasswordChange,
                child: _isLoading ? const CircularProgressIndicator() : const Text('Ubah Kata Sandi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
