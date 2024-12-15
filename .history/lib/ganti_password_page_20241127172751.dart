import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_updatePasswordStrength);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
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
    
    if (_hasMinLength && _hasUppercase && _hasLowercase && _hasDigit && _hasSpecialChar) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Future<void> _updatePasswordInDatabase(String oldPassword, String newPassword) async {
    final url = Uri.parse('https://yourapi.com/change-password');  // Ganti dengan endpoint API Anda
    final response = await http.post(
      url,
      body: json.encode({
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Jika sukses, tampilkan notifikasi sukses
      _showSuccessNotification();
    } else {
      // Jika gagal, tampilkan notifikasi error
      _showErrorNotification('Terjadi kesalahan saat mengubah kata sandi');
    }
  }

  void _showSuccessNotification() {
    ElegantNotification.success(
      title: const Text(
        "Berhasil!",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text(
        "Kata sandi Anda berhasil diperbarui",
        style: TextStyle(
          fontSize: 14,
        ),
      ),
      animation: AnimationType.fromTop,
      position: Alignment.topCenter,
      isDismissable: true,
      showProgressIndicator: false,
      width: 360,
      toastDuration: const Duration(seconds: 3),
      autoDismiss: true,
    ).show(context);
  }

  void _showErrorNotification(String message) {
    ElegantNotification.error(
      title: const Text(
        "Gagal!",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      animation: AnimationType.fromTop,
      position: Alignment.topCenter,
      isDismissable: true,
      showProgressIndicator: false,
      width: 360,
      toastDuration: const Duration(seconds: 3),
      autoDismiss: true,
    ).show(context);
  }

  Future<void> _handlePasswordChange() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Kirim permintaan untuk mengubah kata sandi
        await _updatePasswordInDatabase(
          _oldPasswordController.text,
          _newPasswordController.text,
        );
      } catch (e) {
        // Jika terjadi error
        if (mounted) {
          _showErrorNotification("Terjadi kesalahan saat mengubah kata sandi");
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Fungsi untuk menampilkan dialog sukses
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sukses'),
        content: const Text('Kata sandi Anda berhasil diubah'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membangun TextFormField
  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool obscureText,
    String? Function(String?) validator,
    VoidCallback onToggleVisibility,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Kata Sandi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildPasswordField(
                'Kata Sandi Lama',
                _oldPasswordController,
                _obscureOldPassword,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kata sandi lama tidak boleh kosong';
                  }
                  return null;
                },
                () {
                  setState(() {
                    _obscureOldPassword = !_obscureOldPassword;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                'Kata Sandi Baru',
                _newPasswordController,
                _obscureNewPassword,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kata sandi baru tidak boleh kosong';
                  }
                  return null;
                },
                () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                'Konfirmasi Kata Sandi Baru',
                _confirmPasswordController,
                _obscureConfirmPassword,
                (value) {
                  if (value != _newPasswordController.text) {
                    return 'Kata sandi tidak cocok';
                  }
                  return null;
                },
                () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _handlePasswordChange,
                      child: const Text('Ubah Kata Sandi'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
