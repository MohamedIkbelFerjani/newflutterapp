import 'package:Smartmeter/home.dart';
import 'package:Smartmeter/technician/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _fullNameController = TextEditingController();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  final TextEditingController _companyNameController = TextEditingController();
  String _selectedGender = 'male';
  late FirebaseAuth _auth;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _auth = FirebaseAuth.instance;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _saveUserData(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fullName': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'companyName': _companyNameController.text.trim(),
        'gender': _selectedGender,
        'password': _passwordController.text.trim(),
      });
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  void _createAccount() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset error message
    });

    try {
      if (_passwordController.text != _confirmPasswordController.text) {
        // Passwords don't match
        setState(() {
          _isLoading = false;
          _errorMessage = 'Passwords do not match';
        });
        return;
      }

      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final User? user = userCredential.user;

      if (user != null) {
        // Account created successfully
        await _saveUserData(user.uid); // Save user data to Firestore
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SignInPage(),
        ));

        print('Account created: ${user.uid}');
      } else {
        // Handle other cases, such as account creation failed
        print('Unable to create account');
      }
    } catch (e) {
      print('Error creating account: $e');
      // Handle the error
      setState(() {
        _errorMessage = 'Error creating account';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Fond blanc
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Inscription',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Texte rouge
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Nom complet',
                    labelStyle: TextStyle(color: Colors.grey), // Label en rouge
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: Colors.blue), // Bordure fine bleue
                    ),
                    filled: true,
                    fillColor: Colors.white, // Champ blanc
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  style: TextStyle(color: Colors.grey), // Texte gris
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey), // Label en rouge
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: Colors.blue), // Bordure fine bleue
                    ),
                    filled: true,
                    fillColor: Colors.white, // Champ blanc
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.grey), // Texte gris
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _companyNameController,
                  decoration: InputDecoration(
                    labelText: 'Nom de l\'entreprise',
                    labelStyle: TextStyle(color: Colors.grey), // Label en rouge
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: Colors.blue), // Bordure fine bleue
                    ),
                    filled: true,
                    fillColor: Colors.white, // Champ blanc
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  style: TextStyle(color: Colors.grey), // Texte gris
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    labelStyle: TextStyle(color: Colors.grey), // Label en rouge
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: Colors.blue), // Bordure fine bleue
                    ),
                    filled: true,
                    fillColor: Colors.white, // Champ blanc
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  obscureText: true,
                  style: TextStyle(color: Colors.grey), // Texte gris
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirmer le mot de passe',
                    labelStyle: TextStyle(color: Colors.grey), // Label en rouge
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: Colors.blue), // Bordure fine bleue
                    ),
                    filled: true,
                    fillColor: Colors.white, // Champ blanc
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  obscureText: true,
                  style: TextStyle(color: Colors.grey), // Texte gris
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Genre: ',
                        style: TextStyle(fontSize: 16, color: Colors.blue)),
                    SizedBox(width: 10),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'male',
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.red), // Radio rouge
                        ),
                        Text('Homme', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    SizedBox(width: 10),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'female',
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.red), // Radio rouge
                        ),
                        Text('Femme', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  _errorMessage ?? '', // Show error message here
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _createAccount,
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white), // Spinner blanc
                        )
                      : Text('Créer un compte',
                          style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.blue, // Bouton bleu
                    textStyle: TextStyle(color: Colors.white), // Texte blanc
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
