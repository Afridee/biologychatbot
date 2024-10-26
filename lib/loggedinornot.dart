import 'package:biologychatbot/loginPage.dart';
import 'package:biologychatbot/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'chatPage.dart';
import 'onboardingScreens.dart';

class LoggedInOrNot extends StatefulWidget {
  const LoggedInOrNot({Key? key}) : super(key: key);

  @override
  State<LoggedInOrNot> createState() => _LoggedInOrNotState();
}

class _LoggedInOrNotState extends State<LoggedInOrNot> {
  final authService = Get.put(AuthService());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthService>(builder: (as){
     return as.isLoading ?   Scaffold(
       body: Center(
         child: Padding(
           padding: const EdgeInsets.all(120.0),
           child: Lottie.asset(
             'assets/animations/cellDividing.json',
             fit: BoxFit.cover,
           ),
         ),
       ),
     )   :  as.isSignedIn() ?  ChatScreen() : OnboardingScreen();
    });
  }
}
