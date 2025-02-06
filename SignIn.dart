// import 'package:Smartmeter/home.dart';
// import 'package:Smartmeter/signUp.dart';
// import 'package:Smartmeter/technician/signup.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class SignIn extends StatefulWidget {
//   const SignIn({super.key});

//   @override
//   _SignInState createState() => _SignInState();
// }

// class _SignInState extends State<SignIn> {
//   late final TextEditingController _emailController;
//   late final TextEditingController _passwordController;
//   late FirebaseAuth _auth;
//   bool _isLoading = false;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _emailController = TextEditingController();
//     _passwordController = TextEditingController();
//     _auth = FirebaseAuth.instance;
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _signIn() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null; // Reset error message
//     });

//     try {
//       final UserCredential userCredential =
//           await _auth.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//       final User? user = userCredential.user;

//       if (user != null) {
//         // User is signed in.
//         // Navigate to the Accueil page
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => const Home(),
//         ));
//       } else {
//         // Handle other cases, such as incorrect email/password
//         setState(() {
//           _errorMessage = 'Incorrect email or password';
//         });
//       }
//     } catch (e) {
//       print('Error signing in: $e');
//       // Handle the error
//       setState(() {
//         _errorMessage = 'Incorrect email or password';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.asset(
//             'images/backgroound.jpg',
//             fit: BoxFit.cover,
//           ),
//           Container(
//             color: Colors.black
//                 .withOpacity(0.5), // Optional: Add a semi-transparent overlay
//           ),
//           Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   const Text(
//                     'Sign In ',
//                     style: TextStyle(
//                       fontSize: 32.0,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   TextField(
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       labelStyle: TextStyle(
//                           color: Colors.black), // Make label text white
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[200], // Adjust fill color opacity
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                     ),
//                     keyboardType: TextInputType.emailAddress,
//                     style:
//                         TextStyle(color: Colors.black), // Make input text white
//                   ),
//                   SizedBox(height: 20),
//                   TextField(
//                     controller: _passwordController,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       labelStyle: TextStyle(
//                           color: Colors.black), // Make label text white
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[200], // Adjust fill color opacity
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                     ),
//                     obscureText: true,
//                     style:
//                         TextStyle(color: Colors.black), // Make input text white
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     _errorMessage ?? '', // Show error message here
//                     style: TextStyle(color: Colors.red),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _isLoading ? null : _signIn,
//                     child: _isLoading
//                         ? CircularProgressIndicator()
//                         : Text('Sign In'),
//                     style: ElevatedButton.styleFrom(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                       textStyle: TextStyle(fontSize: 18),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Don't have an account? ",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => SignUpPage()));
//                         },
//                         child: Text(
//                           'Sign Up',
//                           style: TextStyle(
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                         style:
//                             TextButton.styleFrom(foregroundColor: Colors.blue),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
///////////////////////////////////////////////
// import 'package:Smartmeter/home.dart';
// import 'package:Smartmeter/signUp.dart';
// import 'package:Smartmeter/technician/signup.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class SignIn extends StatefulWidget {
//   const SignIn({super.key});

//   @override
//   _SignInState createState() => _SignInState();
// }

// class _SignInState extends State<SignIn> {
//   late final TextEditingController _emailController;
//   late final TextEditingController _passwordController;
//   late FirebaseAuth _auth;
//   bool _isLoading = false;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _emailController = TextEditingController();
//     _passwordController = TextEditingController();
//     _auth = FirebaseAuth.instance;
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _signIn() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null; // Reset error message
//     });

//     try {
//       final UserCredential userCredential =
//           await _auth.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//       final User? user = userCredential.user;

//       if (user != null) {
//         // User is signed in.
//         // Navigate to the Accueil page
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => const Home(),
//         ));
//       } else {
//         // Handle other cases, such as incorrect email/password
//         setState(() {
//           _errorMessage = 'Email ou mot de passe incorrect';
//         });
//       }
//     } catch (e) {
//       print('Error signing in: $e');
//       // Handle the error
//       setState(() {
//         _errorMessage = 'Email ou mot de passe incorrect';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.white, // Set the background color to white
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 const Text(
//                   'Se connecter ',
//                   style: TextStyle(
//                     fontSize: 32.0,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue, // Change the text color to blue
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 TextField(
//                   controller: _emailController,
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     labelStyle: TextStyle(
//                         color: Colors.blue), // Change label text to blue
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide: BorderSide(
//                           color: Colors.blue), // Add a thin blue stroke
//                     ),
//                     filled: true,
//                     fillColor: Colors.white, // Keep the input fields white
//                     contentPadding:
//                         EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   style:
//                       TextStyle(color: Colors.black), // Keep input text black
//                 ),
//                 SizedBox(height: 20),
//                 TextField(
//                   controller: _passwordController,
//                   decoration: InputDecoration(
//                     labelText: 'Mot de passe',
//                     labelStyle: TextStyle(
//                         color: Colors.blue), // Change label text to blue
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide: BorderSide(
//                           color: Colors.blue), // Add a thin blue stroke
//                     ),
//                     filled: true,
//                     fillColor: Colors.white, // Keep the input fields white
//                     contentPadding:
//                         EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                   ),
//                   obscureText: true,
//                   style:
//                       TextStyle(color: Colors.black), // Keep input text black
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   _errorMessage ?? '', // Show error message here
//                   style: TextStyle(color: Colors.red),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _isLoading ? null : _signIn,
//                   child: _isLoading
//                       ? CircularProgressIndicator(
//                           valueColor: AlwaysStoppedAnimation<Color>(Colors
//                               .white), // Make the progress indicator white
//                         )
//                       : Text(
//                           'Se connecter',
//                           style: TextStyle(
//                               color: Colors
//                                   .white), // Set the button text color to white
//                         ),
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                     backgroundColor: Colors.blue,
//                     textStyle: TextStyle(
//                         fontSize:
//                             18), // Set the button background color to blue
//                     elevation: 0, // Remove the button shadow/elevation
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Vous n'avez pas de compte ?",
//                       style: TextStyle(color: Colors.grey), // Change to blue
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) => SignUpPage()));
//                       },
//                       child: Text(
//                         'S inscrire',
//                         style: TextStyle(
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                       style: TextButton.styleFrom(foregroundColor: Colors.blue),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
///////////////////////////////////////////
///import 'package:Smartmeter/home.dart';
import 'package:Smartmeter/home.dart';
import 'package:Smartmeter/notification.dart';
import 'package:Smartmeter/signUp.dart';
import 'package:Smartmeter/technician/signup.dart';
import 'package:Smartmeter/add.dart'; // Import the new page
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late FirebaseAuth _auth;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _auth = FirebaseAuth.instance;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset error message
    });

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final User? user = userCredential.user;

      if (user != null) {
        // User is signed in.
        // Navigate to the Add Voltage page
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Home(),
        ));
      } else {
        // Handle other cases, such as incorrect email/password
        setState(() {
          _errorMessage = 'Email ou mot de passe incorrect';
        });
      }
    } catch (e) {
      print('Error signing in: $e');
      // Handle the error
      setState(() {
        _errorMessage = 'Email ou mot de passe incorrect';
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
        color: Colors.white, // Set the background color to white
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Se connecter',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Change the text color to blue
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                        color: Colors.blue), // Change label text to blue
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Colors.blue), // Add a thin blue stroke
                    ),
                    filled: true,
                    fillColor: Colors.white, // Keep the input fields white
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style:
                      TextStyle(color: Colors.black), // Keep input text black
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    labelStyle: TextStyle(
                        color: Colors.blue), // Change label text to blue
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Colors.blue), // Add a thin blue stroke
                    ),
                    filled: true,
                    fillColor: Colors.white, // Keep the input fields white
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  obscureText: true,
                  style:
                      TextStyle(color: Colors.black), // Keep input text black
                ),
                SizedBox(height: 20),
                Text(
                  _errorMessage ?? '', // Show error message here
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors
                              .white), // Make the progress indicator white
                        )
                      : Text(
                          'Se connecter',
                          style: TextStyle(
                              color: Colors
                                  .white), // Set the button text color to white
                        ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          SignUp(), // Navigate to Sign Up page
                    ));
                  },
                  child: Text(
                    'Créer un compte',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        decoration: TextDecoration.underline),
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
