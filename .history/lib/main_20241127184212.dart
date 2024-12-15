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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/forgot_password': (context) => ForgotPasswordPage(),
        '/home': (context) => HomePage(),
        '/booking': (context) => BookingPage(),
        '/doctor_schedule': (context) => DoctorSchedulePage(),
        '/health_history': (context) => RiwayatKesehatanPage(),
        '/emergency_contact': (context) => KontakDaruratPage(),
        '/profile': (context) => ProfilePage(),
        '/edit_profile': (context) => EditProfilePage(),
        '/ganti_password': (context) => ChangePasswordPage(),
        '/notifikasi_set': (context) => NotificationSettingsPage(),
        '/bantuan': (context) => HelpPage(),
        '/consultation': (context) => ConsultationPage(),
        '/psikolog_tes': (context) => PsychTestPage(),
      },
    );
  }
}
