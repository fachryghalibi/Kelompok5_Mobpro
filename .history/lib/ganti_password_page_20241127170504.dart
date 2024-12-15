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

class _ChangePasswordPageState extends State<ChangePasswordPage>
    with SingleTickerProviderStateMixin {
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

    if (_hasMinLength &&
        _hasUppercase &&
        _hasLowercase &&
        _hasDigit &&
        _hasSpecialChar) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Future<void> _handlePasswordChange() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final url = Uri.parse("https://example.com/api/change-password"); // Ganti dengan URL API Anda
      final body = {
        "old_password": _oldPasswordController.text,
        "new_password": _newPasswordController.text,
      };

      try {
        final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(body),
        );

        final data = jsonDecode(response.body);

        if (response.statusCode == 200 && data['success'] == true) {
          _showSuccessNotification();
          _showSuccessDialog();
        } else {
          _showErrorNotification(data['message'] ?? "Terjadi kesalahan.");
        }
      } catch (e) {
        _showErrorNotification("Gagal terhubung ke server.");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessNotification() {
    ElegantNotification.success(
      title: const Text(
        "Berhasil!",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: const Text(
        "Kata sandi Anda berhasil diperbarui.",
        style: TextStyle(fontSize: 14),
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
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(
        message,
        style: const TextStyle(fontSize: 14),
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sukses"),
          content: const Text("Kata sandi Anda berhasil diubah."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Return to previous page
              },
            ),
          ],
        );
      },
    );
  }

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
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
        title: const Text("Ubah Kata Sandi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildPasswordField(
                "Kata Sandi Lama",
                _oldPasswordController,
                _obscureOldPassword,
                (value) => value!.isEmpty ? "Masukkan kata sandi lama" : null,
                () => setState(() {
                  _obscureOldPassword = !_obscureOldPassword;
                }),
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                "Kata Sandi Baru",
                _newPasswordController,
                _obscureNewPassword,
                (value) {
                  if (value!.isEmpty) {
                    return "Masukkan kata sandi baru";
                  }
                  if (!_hasMinLength ||
                      !_hasUppercase ||
                      !_hasLowercase ||
                      !_hasDigit ||
                      !_hasSpecialChar) {
                    return "Kata sandi tidak memenuhi semua persyaratan.";
                  }
                  return null;
                },
                () => setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                }),
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                "Konfirmasi Kata Sandi Baru",
                _confirmPasswordController,
                _obscureConfirmPassword,
                (value) {
                  if (value!.isEmpty) {
                    return "Konfirmasi kata sandi baru";
                  }
                  if (value != _newPasswordController.text) {
                    return "Kata sandi tidak cocok";
                  }
                  return null;
                },
                () => setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                }),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _handlePasswordChange,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Ubah Kata Sandi"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
