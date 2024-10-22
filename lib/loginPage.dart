import 'package:biologychatbot/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {

  final authService = Get.put(AuthService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Image.asset("assets/images/icon.png", width: 200),
              ),
              InkWell(
                onTap: (){
                  authService.signIn();
                },
                child: Card(
                  color: Color(0xFF1E454F), // Deep Blue Green
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text (
                          'Login with google',
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xFF4EF28F), // Bright Green
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}