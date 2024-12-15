import 'package:flutter/material.dart';
import 'package:tubesmopro/login_page.dart';
import 'package:tubesmopro/register_page.dart';
import 'package:tubesmopro/forgot_password_page.dart';
import 'package:tubesmopro/home_page.dart';
import 'package:tubesmopro/booking_page.dart';
import 'package:tubesmopro/doctor_schedule_page.dart';
import 'package:tubesmopro/riwayat_kesehatan_page.dart';
import 'package:tubesmopro/kontak_darurat_page.dart';
import 'package:tubesmopro/profile_page.dart';
import 'package:tubesmopro/edit_profile_page.dart';
import 'package:tubesmopro/ganti_password_page.dart';
import 'package:tubesmopro/pengaturan_notifikasi_page.dart';
import 'package:tubesmopro/bantuan_page.dart';
import 'package:tubesmopro/konsultasi_online_page.dart';
import 'package:tubesmopro/psikologi_test.dart';
import 'package:tubesmopro/utility/local_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Klinik Kesehatan Kampus',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/ganti_password') {
          // Extract the userId from arguments
          final args = settings.arguments as Map<String, dynamic>?;
          final userId = args?['userId'] as int?;
          
          if (userId == null) {
            return MaterialPageRoute(
              builder: (context) => const ErrorPage(
                message: 'User ID is required for password change',
              ),
            );
          }
          
          return MaterialPageRoute(
            builder: (context) => ChangePasswordPage(userId: userId),
          );
        }
        return null;
      },
      routes: {
        '/': (context) =>  LoginPage(),
        '/register': (context) =>  RegisterPage(),
        '/forgot_password': (context) =>  ForgotPasswordPage(),
        '/home': (context) =>  HomePage(),
        '/booking': (context) =>  BookingPage(),
        '/doctor_schedule': (context) =>  DoctorSchedulePage(),
        '/health_history': (context) =>  RiwayatKesehatanPage(),
        '/emergency_contact': (context) =>  KontakDaruratPage(),
        '/profile': (context) =>  ProfilePage(),
        '/edit_profile': (context) =>  EditProfilePage(),
        '/notifikasi_set': (context) =>  NotificationSettingsPage(),
        '/bantuan': (context) =>  HelpPage(),
        '/consultation': (context) =>  ConsultationPage(),
        '/psikolog_tes': (context) =>  PsychTestPage(),
      },
    );
  }
}

// Simple error page to handle missing userId
class ErrorPage extends StatelessWidget {
  final String message;
  
  const ErrorPage({Key? key, required this.message}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text(message)),
    );
  }
}