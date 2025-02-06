import 'package:Smartmeter/SignIn.dart';
import 'package:Smartmeter/technician/signin.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white, // Set background to white
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, // Align items to the top
            children: [
              SizedBox(height: 60),

              // Background Image at the top
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipOval(
                    child: Image.asset(
                      'images/logoapp.jpg',
                      width: 150,
                      height: 150,
                      fit: BoxFit
                          .cover, // Ensures the image covers the circular frame
                    ),
                  ),
                ),
              ),

              SizedBox(height: 80),
              // Welcome message and buttons
              Text(
                'Bienvenue dans notre application',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Text color set to black
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              OutlinedButton(
                onPressed: () {
                  // Navigate to the TechniciansPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignInPage(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  side: BorderSide(
                      color: Colors.blue, width: 2), // Blue stroke (border)
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text(
                  'Compte Steg',
                  style: TextStyle(
                    color: Colors.blue, // Text color set to blue
                  ),
                ),
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  // Navigate to the UserPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignIn(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  side: BorderSide(
                      color: Colors.red, width: 2), // Red stroke (border)
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text(
                  'Compte client',
                  style: TextStyle(
                    color: Colors.red, // Text color set to red
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder for TechniciansPage and UserPage
class TechniciansPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Technicians')),
      body: Center(child: Text('Technicians Page')),
    );
  }
}

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: Center(child: Text('User Page')),
    );
  }
}
