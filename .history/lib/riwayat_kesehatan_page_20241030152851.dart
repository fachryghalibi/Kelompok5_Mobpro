import 'package:flutter/material.dart';
//fahri
class RiwayatKesehatanPage extends StatelessWidget {
  final List<Map<String, String>> healthHistory = [
    {
      'date': '2024-09-10',
      'condition': 'Check-up Umum',
      'details': 'Pemeriksaan tekanan darah dan kadar gula.'
    },
    {
      'date': '2024-08-22',
      'condition': 'Flu dan Demam',
      'details': 'Diagnosis flu biasa, diberikan obat flu dan demam.'
    },
    {
      'date': '2024-07-15',
      'condition': 'Cedera Lutut',
      'details': 'Cedera akibat olahraga, diberikan fisioterapi.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Kesehatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: healthHistory.length,
          itemBuilder: (context, index) {
            final record = healthHistory[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record['condition']!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tanggal: ${record['date']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      record['details']!,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
