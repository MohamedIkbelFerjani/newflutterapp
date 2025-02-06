import 'package:Smartmeter/home.dart';
import 'package:Smartmeter/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChartsPage extends StatelessWidget {
  const ChartsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchData(), // Fetch data from Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data!;

          // Calculate monthly totals for voltage, power, and current
          double totalMonthlyVoltage = 0.0;
          double totalMonthlyPower = 0.0;
          double totalMonthlyCurrent = 0.0;
          final currentMonth = DateFormat('yyyy-MM').format(DateTime.now());

          for (var entry in data) {
            if (entry['date'].startsWith(currentMonth)) {
              totalMonthlyVoltage += entry['voltage'];
              totalMonthlyPower += entry['power'];
              totalMonthlyCurrent += entry['current'];
            }
          }

          // Trigger notifications if any monthly total exceeds 150
          if (totalMonthlyVoltage > 150) {
            NotificationService().showNotification(
              id: 6,
              title: "Monthly Voltage Alert",
              body: "This month's total voltage has exceeded 150 V!",
            );
          }

          if (totalMonthlyPower > 150) {
            NotificationService().showNotification(
              id: 7,
              title: "Monthly Power Alert",
              body: "This month's total power consumption has exceeded 150 W!",
            );
          }

          if (totalMonthlyCurrent > 150) {
            NotificationService().showNotification(
              id: 8,
              title: "Monthly Current Alert",
              body: "This month's total current has exceeded 150 A!",
            );
          }

          // Display today's data
          final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
          final todayData = data.firstWhere(
            (entry) => entry['date'] == today,
            orElse: () => {
              'voltage': 0.0,
              'power': 0.0,
              'current': 0.0,
            } as Map<String, Object>,
          );

          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InfoBox(
                      icon: Icons.electric_bolt,
                      label: 'Voltage',
                      value: '${todayData['voltage']} V',
                      color: Color.fromARGB(255, 224, 202, 0),
                    ),
                    InfoBox(
                      icon: Icons.electric_meter,
                      label: 'Power',
                      value: '${todayData['power']} W',
                      color: Colors.red,
                    ),
                    InfoBox(
                      icon: Icons.electric_bolt,
                      label: 'Current',
                      value: '${todayData['current']} A',
                      color: Colors.blue,
                    ),
                  ],
                ),
                _buildBarChart(data, 'Voltage', 'voltage',
                    Color.fromARGB(255, 224, 202, 0)),
                const SizedBox(height: 20),
                _buildBarChart(data, 'Power', 'power', Colors.red),
                const SizedBox(height: 20),
                _buildBarChart(data, 'Current', 'current', Colors.blue),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    // Fetch data from Firestore
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('days')
        .get();

    return snapshot.docs
        .map((doc) => {
              'date': (doc['date'] as String),
              'voltage': double.tryParse(doc['voltage'] ?? '0') ?? 0.0,
              'power': double.tryParse(doc['power'] ?? '0') ?? 0.0,
              'current': double.tryParse(doc['current'] ?? '0') ?? 0.0,
            })
        .toList();
  }

  Widget _buildBarChart(
      List<Map<String, dynamic>> data, String title, String key, Color color) {
    return Container(
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BarChart(
                BarChartData(
                  maxY: 150,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              data[value.toInt()]['date'],
                              style: const TextStyle(fontSize: 7),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final value = entry.value[key] as double;
                    return BarChartGroupData(x: index, barRods: [
                      BarChartRodData(toY: value, color: color),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
