import 'package:Smartmeter/home.dart';
import 'package:Smartmeter/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ConsomationPrixPage extends StatelessWidget {
  const ConsomationPrixPage({Key? key}) : super(key: key);

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

          // Calculate total consumption and price for the current month
          double totalConsomation = 0.0;
          double totalPrix = 0.0;
          final currentMonth = DateFormat('yyyy-MM').format(DateTime.now());

          for (var entry in data) {
            if (entry['date'].startsWith(currentMonth)) {
              totalConsomation += entry['consomation'];
              totalPrix += entry['prix'];
            }
          }

          // Check if total consumption for the month exceeds 150
          // Check if total consumption for the month exceeds 150
          if (totalConsomation >= 150) {
            NotificationService().showNotification(
              id: 1, // Unique ID for the consumption notification
              title: "Consommation Alert",
              body: "You have consumed over 150 kWh this month!",
            );
          }

// Check if total price for the month exceeds 150
          if (totalPrix >= 150) {
            NotificationService().showNotification(
              id: 2, // Unique ID for the price notification
              title: "Price Alert",
              body: "Your total price has exceeded \$150 this month!",
            );
          }

          // Filter today's data
          final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
          final todayData = data.firstWhere(
            (entry) => entry['date'] == today,
            orElse: () => {
              'consomation': 0.0,
              'prix': 0.0,
            } as Map<String, Object>, // Cast to Map<String, Object>
          );

          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InfoBox(
                      icon: Icons.energy_savings_leaf,
                      label: 'Consommation',
                      value: '${todayData['consomation']} kWh',
                      color: Colors.orange,
                    ),
                    InfoBox(
                      icon: Icons.price_check,
                      label: 'Prix',
                      value: '\$${todayData['prix']}',
                      color: Colors.purple,
                    ),
                  ],
                ),
                _buildBarChart(
                    data, 'Consommation', 'consomation', Colors.orange),
                const SizedBox(height: 20),
                _buildBarChart(data, 'Prix', 'prix', Colors.purple),
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
              'consomation': double.tryParse(doc['consomation'] ?? '0') ?? 0.0,
              'prix': double.tryParse(doc['prix'] ?? '0') ?? 0.0,
            })
        .toList();
  }

  Widget _buildBarChart(
      List<Map<String, dynamic>> data, String title, String key, Color color) {
    return Container(
      height: 300, // Ensure this height is set
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
            // Use Expanded here to ensure BarChart takes available space
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BarChart(
                BarChartData(
                  maxY: 150, // Set maximum Y value as needed
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true, // Show y-axis titles
                        reservedSize: 40, // Reserve space for y-axis titles
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(), // Display y-axis value
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
                              data[value.toInt()]
                                  ['date'], // X-axis labels from data
                              style: const TextStyle(fontSize: 7),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final value =
                        entry.value[key] as double; // Access the desired value
                    return BarChartGroupData(x: index, barRods: [
                      BarChartRodData(
                          toY: value, color: color), // Set color for bars
                    ]);
                  }).toList(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
