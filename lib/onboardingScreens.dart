import 'package:biologychatbot/loginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';

import 'constants/constants.dart';

class OnboardingScreen extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: 'All Subjects Covered',
      subTitle: 'From science to math, history to literature – all core subjects are available in one app.',
      imageUrl: 'assets/images/Research paper-bro.png',
      titleTextStyle: TextStyle(color: bright_green,fontSize: 25),
      subTitleTextStyle: const TextStyle(color: Colors.white, fontSize: 15),
    ),
    Introduction(
      title: 'Interactive Learning',
      subTitle: 'Answer multiple-choice, true/false, and short-answer biology questions. Improve your knowledge with real-time feedback and detailed explanations.',
      imageUrl: 'assets/images/Learning-bro.png',
      titleTextStyle: TextStyle(color: bright_green,fontSize: 25),
      subTitleTextStyle: const TextStyle(color: Colors.white, fontSize: 15),
    ),
    Introduction(
      title: 'Exam Preparation',
      subTitle: 'Prepare for your exams with practice questions aligned to IB, Cambridge, and other curricula. Review mark schemes and key points to ace your biology tests.',
      imageUrl: 'assets/images/Exams-bro.png',
      titleTextStyle: TextStyle(color: bright_green,fontSize: 25),
      subTitleTextStyle: const TextStyle(color: Colors.white, fontSize: 15),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      backgroudColor: deep_blue_green,
      foregroundColor: bright_green,
      skipTextStyle: const TextStyle(color: Colors.white),
      introductionList: list,
      onTapSkipButton: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ), //MaterialPageRoute
        );
      },
    );
  }
}