// import 'package:Smartmeter/chat.dart';
// import 'package:Smartmeter/models/technician.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class SignUpPage extends StatefulWidget {
//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   File? _profileImage;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _isLoading = false;
//   String? _errorMessage;

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _profileImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<String?> _uploadProfileImage(File imageFile) async {
//     try {
//       String fileName = 'profile_images/${_auth.currentUser!.uid}.jpg';
//       UploadTask uploadTask =
//           FirebaseStorage.instance.ref(fileName).putFile(imageFile);
//       TaskSnapshot snapshot = await uploadTask;
//       String downloadUrl = await snapshot.ref.getDownloadURL();
//       return downloadUrl;
//     } catch (e) {
//       print('Error uploading profile image: $e');
//       return null;
//     }
//   }

//   Future<void> _saveUserData(String userId) async {
//     String? profileImageUrl = '';
//     if (_profileImage != null) {
//       profileImageUrl = await _uploadProfileImage(_profileImage!);
//     }
//     await FirebaseFirestore.instance.collection('technicians').doc(userId).set({
//       'fullName': _fullNameController.text.trim(),
//       'email': _emailController.text.trim(),
//       'profileImageUrl': profileImageUrl ?? '',
//     });
//   }

//   void _createAccount() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       if (_passwordController.text != _confirmPasswordController.text) {
//         setState(() {
//           _errorMessage = 'Passwords do not match';
//           _isLoading = false;
//         });
//         return;
//       }

//       final UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//       final User? user = userCredential.user;

//       if (user != null) {
//         await _saveUserData(user.uid);
//         Technician technician = Technician(
//           name: _fullNameController.text.trim(),
//           userEmail: user.email ?? 'unknown@example.com',
//           imagePath: 'https://example.com/profile.png', id: '',
//           location: '', // Update accordingly
//         );

//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => ChatPage()),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error creating account: ${e.toString()}';
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
//           Image.network(
//               'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnSA1zygA3rubv-VK0DrVcQ02Po79kJhXo_A&s',
//               fit: BoxFit.cover),
//           Container(color: Colors.black.withOpacity(0.5)),
//           Center(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   Text(
//                     'Sign Up as Technician',
//                     style: TextStyle(
//                         fontSize: 32.0,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white),
//                   ),
//                   SizedBox(height: 20),
//                   GestureDetector(
//                     onTap: _pickImage,
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundImage: _profileImage != null
//                           ? FileImage(_profileImage!)
//                           : AssetImage('images/dfperson.png') as ImageProvider,
//                       child: _profileImage == null
//                           ? Icon(Icons.camera_alt,
//                               size: 30, color: Colors.white)
//                           : null,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   TextField(
//                     controller: _fullNameController,
//                     decoration: InputDecoration(
//                       labelText: 'Full Name',
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30)),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   TextField(
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30)),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   TextField(
//                     controller: _passwordController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30)),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   TextField(
//                     controller: _confirmPasswordController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       labelText: 'Confirm Password',
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30)),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   if (_errorMessage != null)
//                     Text(_errorMessage!, style: TextStyle(color: Colors.red)),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _isLoading ? null : _createAccount,
//                     child: _isLoading
//                         ? CircularProgressIndicator()
//                         : Text('Sign Up'),
//                     style: ElevatedButton.styleFrom(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text("Already have an account? ",
//                           style: TextStyle(color: Colors.white)),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.of(context)
//                               .pop(); // Go back to Sign In page
//                         },
//                         child: Text('Sign In',
//                             style: TextStyle(
//                                 decoration: TextDecoration.underline)),
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
import 'package:Smartmeter/chat.dart';
import 'package:Smartmeter/home.dart';
import 'package:Smartmeter/models/technician.dart';
import 'package:Smartmeter/technician/signin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  File? _profileImage;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _errorMessage;
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
          builder: (context) => const Home(),
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadProfileImage(File imageFile) async {
    try {
      String fileName = 'profile_images/${_auth.currentUser!.uid}.jpg';
      UploadTask uploadTask =
          FirebaseStorage.instance.ref(fileName).putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Erreur lors du téléchargement de l\'image de profil: $e');
      return null;
    }
  }

  Future<void> _saveUserData(String userId) async {
    String? profileImageUrl = '';
    if (_profileImage != null) {
      profileImageUrl = await _uploadProfileImage(_profileImage!);
    }
    await FirebaseFirestore.instance.collection('technicians').doc(userId).set({
      'nomComplet': _fullNameController.text.trim(),
      'email': _emailController.text.trim(),
      'profileImageUrl': profileImageUrl ?? '',
    });
  }

  // void _createAccount() async {
  //   setState(() {
  //     _isLoading = true;
  //     _errorMessage = null;
  //   });

  //   try {
  //     if (_passwordController.text != _confirmPasswordController.text) {
  //       setState(() {
  //         _errorMessage = 'Les mots de passe ne correspondent pas';
  //         _isLoading = false;
  //       });
  //       return;
  //     }

  //     final UserCredential userCredential =
  //         await _auth.createUserWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text.trim(),
  //     );
  //     final User? user = userCredential.user;

  //     if (user != null) {
  //       await _saveUserData(user.uid);
  //       Technician technician = Technician(
  //         name: _fullNameController.text.trim(),
  //         userEmail: user.email ?? 'inconnu@example.com',
  //         imagePath: 'https://example.com/profile.png', id: '',
  //         location: '', // Mettez à jour en conséquence
  //       );

  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (context) => SignInPage()),
  //       );
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _errorMessage = 'Erreur lors de la création du compte: ${e.toString()}';
  //     });
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Fond d'écran blanc
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.0, 35, 16, 0),
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                      'Inscription en tant que Utilisateur',
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue), // Texte en bleu
                    ),
                  ),
                ),
                SizedBox(height: 0),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 100, // Adjust the size as needed
                    height: 100, // Adjust the size as needed
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue, // Blue stroke color
                        width: 1, // Stroke width
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : AssetImage('images/dfperson.png') as ImageProvider,
                      child: _profileImage == null
                          ? Icon(Icons.camera_alt,
                              size: 30,
                              color: Colors.blue) // Icône caméra bleue
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Nom Complet',
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
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirmez le mot de passe',
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
                  onPressed: _isLoading ? null : _createAccount,
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white), // Couleur du spinner en blanc
                        )
                      : Text(
                          'S\'inscrire',
                          style: TextStyle(color: Colors.white),
                        ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.blue, // Bouton bleu
                    textStyle: TextStyle(color: Colors.white), // Texte blanc
                    elevation: 0, // Pas d'ombre
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Vous avez déjà un compte? ",
                        style: TextStyle(color: Colors.black)), // Texte en bleu
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Retour à la page de connexion
                      },
                      child: Text('Se connecter',
                          style:
                              TextStyle(decoration: TextDecoration.underline)),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
