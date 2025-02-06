import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AddVoltagePage extends StatefulWidget {
  const AddVoltagePage({Key? key}) : super(key: key);

  @override
  _AddVoltagePageState createState() => _AddVoltagePageState();
}

class _AddVoltagePageState extends State<AddVoltagePage> {
  final TextEditingController _voltageController = TextEditingController();
  final TextEditingController _powerController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _consomationController = TextEditingController();
  final TextEditingController _currentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addData() async {
    // Get the current user ID
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Prepare the data to be saved
    final voltage = _voltageController.text.trim();
    final power = _powerController.text.trim();
    final current = _currentController.text.trim();
    final prix = _prixController.text.trim();
    final consomation = _consomationController.text.trim();
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      // Add data to Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('days')
          .add({
        'date': date,
        'voltage': voltage,
        'power': power,
        'current': current,
        'prix': prix,
        'consomation': consomation,
      });

      // Clear the input fields
      _voltageController.clear();
      _powerController.clear();
      _prixController.clear();
      _consomationController.clear();
      _currentController.clear();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data added successfully!'),
      ));
    } catch (e) {
      print('Error adding data: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error adding data!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Voltage, Power, and Current'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _voltageController,
              decoration: InputDecoration(
                labelText: 'Voltage (V)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _prixController,
              decoration: InputDecoration(
                labelText: 'Prix (DNT)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _consomationController,
              decoration: InputDecoration(
                labelText: 'Consomation (C)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _powerController,
              decoration: InputDecoration(
                labelText: 'Power (W)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _currentController,
              decoration: InputDecoration(
                labelText: 'Current (A)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addData,
              child: const Text('Add Data'),
            ),
          ],
        ),
      ),
    );
  }
}
