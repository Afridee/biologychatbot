import 'package:biologychatbot/constants/constants.dart';
import 'package:biologychatbot/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatelessWidget {
  final authService = Get.put(AuthService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deep_blue_green,
      body: GetBuilder<AuthService>(
        builder: (as){
          return Center(
            child: as.isLoading ? Padding(
              padding: const EdgeInsets.all(120.0),
              child: Lottie.asset(
                'assets/animations/cellDividing.json',
                fit: BoxFit.cover,
              ),
            ) : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Image.asset("assets/images/Chatbot-bro.png"),
                  ),
                  const Text(
                    "Hello, It's BioBot",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color(0xFF4EF28F),
                        fontWeight: FontWeight.bold // Bright Green
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Text("Your personalized biology assistant for quick answers, interactive quizzes, and easy-to-understand concepts.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await authService.signIn();
                      if (authService.firebaseAuth.currentUser != null) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Card(
                      color: bright_green, // Deep Blue Green
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 45.0, right: 45, bottom: 10, top: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Sign in',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: dark_navy,
                                  fontWeight: FontWeight.bold// Bright Green
                              ),
                            ),
                            //SizedBox(height: 20),
                            // TextField(
                            //   decoration: InputDecoration(
                            //     labelText: 'Email',
                            //     labelStyle: TextStyle(color: Color(0xFF40C07C)), // Soft Green
                            //     enabledBorder: OutlineInputBorder(
                            //       borderSide: BorderSide(color: Color(0xFF308566)), // Teal
                            //     ),
                            //     focusedBorder: OutlineInputBorder(
                            //       borderSide: BorderSide(color: Color(0xFF4EF28F)), // Bright Green
                            //     ),
                            //   ),
                            //   style: TextStyle(color: Colors.white),
                            // ),
                            // SizedBox(height: 20),
                            // TextField(
                            //   obscureText: true,
                            //   decoration: InputDecoration(
                            //     labelText: 'Password',
                            //     labelStyle: TextStyle(color: Color(0xFF40C07C)), // Soft Green
                            //     enabledBorder: OutlineInputBorder(
                            //       borderSide: BorderSide(color: Color(0xFF308566)), // Teal
                            //     ),
                            //     focusedBorder: OutlineInputBorder(
                            //       borderSide: BorderSide(color: Color(0xFF4EF28F)), // Bright Green
                            //     ),
                            //   ),
                            //   style: TextStyle(color: Colors.white),
                            // ),
                            // SizedBox(height: 20),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     // Handle login action
                            //   },
                            //   style: ElevatedButton.styleFrom(
                            //     primary: Color(0xFF4EF28F), // Bright Green
                            //     padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            //   ),
                            //   child: Text('Login', style: TextStyle(color: Colors.black)),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
