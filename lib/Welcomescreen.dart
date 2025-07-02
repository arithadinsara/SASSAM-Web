import 'package:flutter/material.dart';
import 'loginscreen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 106, 85, 140),
              Color.fromARGB(255, 33, 33, 34),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 100), // Space from the top for logo
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0), // Space below logo
              child: Image(image: AssetImage('assets/logo.png')),
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: screenWidth * 0.08, // Adjust font size
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Attendance Management System',
              style: TextStyle(
                fontSize: screenWidth * 0.05, // Adjust font size
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center, // Center the text
            ),
            const Spacer(), // Pushes content to the top
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const LoginScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = 0.0;
                      const end = 1.0;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return ScaleTransition(
                        scale: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 184, 168, 210),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: const Color.fromARGB(255, 184, 168, 210)),
                ),
                child: const Center(
                  child: Text(
                    "LET'S GO!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Space before bottom text
            const Text(
              'LANKA NIPPON BIZTECH INSTITUTE',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            const SizedBox(height: 20), // Space after bottom text
          ],
        ),
      ),
    );
  }
}
