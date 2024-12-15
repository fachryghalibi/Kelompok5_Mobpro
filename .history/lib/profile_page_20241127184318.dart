import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:tubesmopro/bantuan_page.dart';
import 'package:tubesmopro/edit_profile_page.dart';
import 'package:tubesmopro/ganti_password_page.dart';
import 'package:tubesmopro/pengaturan_notifikasi_page.dart';

//ihsan
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = ''; 
  String email = '';
  int userId = 0;
  @override
  void initState() {
    super.initState();
    _loadUsername(); 
  }

  // Function to load username from SharedPreferences
  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('full_name') ?? 'User'; 
      email = prefs.getString('email') ?? 'Email Tidak Ada';
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Pengguna'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/image/fachry.jpg'),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                username, // Display the username here
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                email, // You can replace this with dynamic email if stored
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            ProfileOption(
              icon: Icons.person,
              title: 'Edit Profil',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              ),
            ),
            ProfileOption(
              icon: Icons.security,
              title: 'Ubah Kata Sandi',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordPage()),
              ),
            ),
            ProfileOption(
              icon: Icons.notifications,
              title: 'Pengaturan Notifikasi',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationSettingsPage()),
              ),
            ),
            ProfileOption(
              icon: Icons.help,
              title: 'Bantuan',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpPage()),
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => showLogoutDialog(context),
                icon: Icon(Icons.logout),
                label: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(150, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ProfileOption widget to display each profile option
class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileOption({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.grey.withOpacity(0.3),
        highlightColor: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Logout function
Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
}

// Logout confirmation dialog
void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Text('Konfirmasi Logout'),
          ],
        ),
        content: Text('Apakah Anda yakin ingin keluar dari Akun?'),
        actions: [
          TextButton(
            child: Text('Batal'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white), 
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              logout(context);
            },
          ),
        ],
      );
    },
  );
}
