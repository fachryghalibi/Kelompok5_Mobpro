import 'package:flutter/material.dart';
import 'package:tubesmopro/service/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _obscurePassword = true;
  bool _rememberMe = false;

  // Instance dari LoginService
  final LoginService _loginService = LoginService();

  // Fungsi untuk menyimpan username setelah login
  void _saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username); // Menyimpan username
  }

Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final response = await _loginService.login(_email, _password);
      print('Respons server: $response'); // Debug respons server

      if (response['success']) {
        final userData = response['data']; // Ambil data pengguna
        print('Data pengguna: $userData'); // Debug data pengguna
        final username = userData['username']; // Ambil username dari respons
        _saveUsername(username);

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showErrorSnackbar(response['message'] ?? 'Login gagal');
      }
    }
  }


  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade400, Colors.teal.shade800],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Hero(
                              tag: 'appIcon',
                              child: CircleAvatar(
                                backgroundColor: Colors.teal.shade50,
                                radius: 40,
                                child: Icon(
                                  Icons.local_hospital,
                                  size: 40,
                                  color: const Color.fromARGB(255, 248, 0, 0),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Telkom Medika',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Silakan login untuk melanjutkan',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 32),
                            _buildEmailField(),
                            SizedBox(height: 16),
                            _buildPasswordField(),
                            SizedBox(height: 8),
                            _buildRememberMeRow(),
                            SizedBox(height: 24),
                            _buildLoginButton(),
                            SizedBox(height: 16),
                            _buildRegisterRow(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Versi 1.0.0',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Email Field
  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Masukkan email Anda',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.teal, width: 2),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Mohon masukkan email';
        } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(value)) {
          return 'Format email tidak valid';
        }
        return null;
      },
      onSaved: (value) => _email = value!,
    );
  }

  // Password Field
  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Masukkan password Anda',
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.teal, width: 2),
        ),
      ),
      obscureText: _obscurePassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Mohon masukkan password';
        }
        return null;
      },
      onSaved: (value) => _password = value!,
    );
  }

  // Remember Me and Forgot Password Row
  Widget _buildRememberMeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value!;
                });
              },
            ),
            Text('Ingat Saya'),
          ],
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/forgot_password');
          },
          child: Text('Lupa Password?'),
        ),
      ],
    );
  }

  // Login Button
  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _login,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: const Color.fromARGB(255, 215, 220, 219),
      ),
      child: Text(
        'Login',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  // Register Row
  Widget _buildRegisterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Belum punya akun?'),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
          child: Text(
            'Daftar Sekarang',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
