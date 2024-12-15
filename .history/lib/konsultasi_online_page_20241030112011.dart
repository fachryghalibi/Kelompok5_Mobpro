// Fachry
import 'package:flutter/material.dart';
import 'package:tubesmopro/utility/local_notification.dart';

class ConsultationPage extends StatefulWidget {
  @override
  _ConsultationPageState createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  final List<Map<String, dynamic>> _doctors = [
    {
      'name': 'Dr. Atyan',
      'specialty': 'Psikolog Klinis',
      'rating': 4.8,
      'experience': '8 tahun',
      'image': 'assets/doctor1.jpg',
      'availableTime': ['09:00', '11:00', '14:00', '16:00'],
    },
    {
      'name': 'Dr. Fachry',
      'specialty': 'Psikiater',
      'rating': 4.9,
      'experience': '10 tahun',
      'image': 'assets/doctor2.jpg',
      'availableTime': ['10:00', '13:00', '15:00', '17:00'],
    },
  ];

  String _selectedDate = 'Hari ini';
  final List<String> _dateOptions = ['Hari ini', 'Besok', '2 hari lagi'];
  String? _selectedDoctorName;
  String? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Konsultasi Online',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.0, 
                right: 16.0, 
                top: 16.0,
                bottom: 80.0, 
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateSelector(),
                  SizedBox(height: 24),
                  Text(
                    'Dokter Tersedia',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  ..._doctors.map((doctor) => _buildDoctorCard(doctor)).toList(),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
  return Positioned(
    left: 0,
    right: 0,
    bottom: 0,
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: _selectedDoctorName != null && _selectedTime != null
            ? () {
                final selectedDoctor = _doctors.firstWhere(
                  (doctor) => doctor['name'] == _selectedDoctorName
                );
                _showBookingConfirmation(context, selectedDoctor, _selectedTime!);
              }
            : null,
        child: Text(
          'Lanjutkan',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          disabledBackgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          minimumSize: Size(double.infinity, 50),
        ),
      ),
    ),
  );
}


  Widget _buildDateSelector() {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _dateOptions.length,
        itemBuilder: (context, index) {
          final date = _dateOptions[index];
          final isSelected = date == _selectedDate;
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(date),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedDate = date;
                  _selectedDoctorName = null;
                  _selectedTime = null;
                });
              },
              selectedColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
    final doctorName = doctor['name'];
    final bool isDoctorSelected = _selectedDoctorName == doctorName;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  child: Icon(Icons.person, size: 40, color: Colors.grey),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        doctor['specialty'],
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text(
                            '${doctor['rating']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.work, color: Colors.grey, size: 16),
                          SizedBox(width: 4),
                          Text(
                            doctor['experience'],
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Waktu Tersedia',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (doctor['availableTime'] as List<String>).map((time) {
                bool isTimeSelected = _selectedTime == time && isDoctorSelected;
                return OutlinedButton(
                  onPressed: () {
                    setState(() {
                      if (isTimeSelected) {
                        _selectedDoctorName = null;
                        _selectedTime = null;
                      } else {
                        _selectedDoctorName = doctorName;
                        _selectedTime = time;
                      }
                    });
                  },
                  child: Text(time),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isTimeSelected ? Colors.white : Theme.of(context).primaryColor,
                    backgroundColor: isTimeSelected ? Theme.of(context).primaryColor : Colors.white,
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingConfirmation(BuildContext context, Map<String, dynamic> doctor, String time) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Konsultasi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Apakah Anda yakin ingin memesan konsultasi dengan:'),
              SizedBox(height: 8),
              Text('${doctor['name']}', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Tanggal: $_selectedDate'),
              Text('Waktu: $time'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Konfirmasi'),
              onPressed: () {
                Navigator.of(context).pop();
                _showBookingSuccess(context);
                LocalNotifications.showSimpleNotification(
                title: 'Booking Berhasil',
                body: 'Konsultasi Anda telah dijadwalkan. Kami akan mengingatkan Anda sebelum waktu konsultasi.',
                payload: 'booking_confirmed',
              );
              },
            ),
          ],
        );
      },
    );
  }

  void _showBookingSuccess(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Booking Berhasil'),
        content: Text(
          'Konsultasi Anda telah berhasil dijadwalkan. Kami akan mengirimkan notifikasi pengingat sebelum waktu konsultasi.',
        ),
        actions: [
          ElevatedButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);

              
            },
          ),
        ],
      );
    },
  );
}
}