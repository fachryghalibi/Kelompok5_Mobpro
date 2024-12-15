import 'package:flutter/material.dart';
//haikal
class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _newMessages = true;
  bool _promotions = false;
  bool _updates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan Notifikasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Atur Notifikasi',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Pesan Baru'),
              subtitle: Text('Terima notifikasi untuk pesan baru.'),
              value: _newMessages,
              onChanged: (bool value) {
                setState(() {
                  _newMessages = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Promosi'),
              subtitle: Text('Terima notifikasi untuk promosi dan penawaran.'),
              value: _promotions,
              onChanged: (bool value) {
                setState(() {
                  _promotions = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Pembaruan Aplikasi'),
              subtitle: Text('Terima notifikasi untuk pembaruan aplikasi.'),
              value: _updates,
              onChanged: (bool value) {
                setState(() {
                  _updates = value;
                });
              },
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Pengaturan notifikasi disimpan!'),
                    ),
                  );
                },
                child: Text('Simpan Pengaturan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
