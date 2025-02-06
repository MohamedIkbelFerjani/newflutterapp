import 'package:Smartmeter/chat.dart';
import 'package:Smartmeter/models/technician.dart'; // Ensure the correct import path
import 'package:Smartmeter/signUp.dart';
import 'package:Smartmeter/technicians.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _errorMessage;

  void _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Check if the email entered is "helloworld@gmail.com"
    if (_emailController.text.trim() != 'gamra.benmarzouka@esprit.tn') {
      setState(() {
        _errorMessage = 'Wrong email'; // Show the error if email doesn't match
      });
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final User? user = userCredential.user;

      if (user != null) {
        Technician technician = Technician(
          name: user.displayName ?? 'Technician',
          userEmail: user.email ?? 'unknown@example.com',
          imagePath: 'https://example.com/profile.png',
          id: '', location: '', // Change this to the correct path
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TechniciansPage(),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de la connexion: ${e.toString()}';
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
        color: Colors.white, // Fond d'écran blanc
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Connexion en tant que STEG',
                  style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue), // Texte en bleu
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey), // Label en bleu
                    filled: true,
                    fillColor: Colors.white, // Champ blanc
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: Colors.blue), // Bordure fine bleue
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    labelStyle: TextStyle(color: Colors.grey), // Label en bleu
                    filled: true,
                    fillColor: Colors.white, // Champ blanc
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: Colors.blue), // Bordure fine bleue
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (_errorMessage != null)
                  Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white), // Spinner en blanc
                        )
                      : Text(
                          'Connexion',
                          style: TextStyle(color: Colors.white),
                        ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.blue, // Bouton bleu
                    textStyle: TextStyle(color: Colors.white), // Texte blanc
                    elevation: 0, // Pas d'ombre
                  ),
                ),
                SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text("Pas de compte? ",
                //         style: TextStyle(color: Colors.blue)), // Texte en bleu
                //     TextButton(
                //       onPressed: () {
                //         Navigator.of(context).push(MaterialPageRoute(
                //             builder: (context) => const SignUp()));
                //       },
                //       child: Text('Inscription',
                //           style:
                //               TextStyle(decoration: TextDecoration.underline)),
                //       style: TextButton.styleFrom(foregroundColor: Colors.red),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
