import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //depedencies format tanggal
//fadlan
class DoctorSchedulePage extends StatelessWidget {
  final List<Map<String, dynamic>> _schedules = [
    {
      'name': 'Dr. Ihsan',
      'startTime': '09:00',
      'endTime': '14:00',
      'days': ['Senin', 'Rabu'],
      'specialty': 'Dokter Umum'
    },
    {
      'name': 'Dr. Fachry',
      'startTime': '13:00',
      'endTime': '18:00',
      'days': ['Selasa', 'Kamis'],
      'specialty': 'Dokter Gigi'
    },
    {
      'name': 'Dr. Fadlan',
      'startTime': '10:00',
      'endTime': '16:00',
      'days': ['Jumat'],
      'specialty': 'Psikolog'
    },
    {
      'name': 'Dr. Atyan',
      'startTime': '10:00',
      'endTime': '16:00',
      'days': ['Jumat'],
      'specialty': 'Cabulers'
    },
  ];

  String _formatSchedule(Map<String, dynamic> schedule) {
    // Parse the time strings to DateTime objects
    final now = DateTime.now();
    final startTime = DateFormat('HH:mm').parse(schedule['startTime']);
    final endTime = DateFormat('HH:mm').parse(schedule['endTime']);

    // Create DateTime objects with today's date for formatting
    final startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,
    );
    final endDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      endTime.hour,
      endTime.minute,
    );

    // Format the times using intl
    final timeFormatter = DateFormat('HH:mm');
    final formattedStartTime = timeFormatter.format(startDateTime);
    final formattedEndTime = timeFormatter.format(endDateTime);

    // Join the days with separator
    final days = schedule['days'].join(' & ');

    return '$days, $formattedStartTime - $formattedEndTime';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jadwal Dokter'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _schedules.length,
        itemBuilder: (context, index) {
          final schedule = _schedules[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.teal,
                radius: 25,
                child: Text(
                  schedule['name'].substring(4, 5),
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              title: Text(
                schedule['name'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.medical_services, size: 16, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(schedule['specialty']),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 16, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(_formatSchedule(schedule)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}