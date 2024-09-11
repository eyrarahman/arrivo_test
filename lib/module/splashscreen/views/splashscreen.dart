import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color(
                0xFFF5F5F5), // Replace with your image's background color
            body: Stack(
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/splash_logo1.jpeg",
                    fit:
                        BoxFit.contain, // Ensures the image stays fully visible
                    width: constraints.maxWidth *
                        0.6, // Adjust the width of the image
                    height: constraints.maxHeight *
                        0.6, // Adjust the height of the image
                    opacity: const AlwaysStoppedAnimation(
                        1), // Make the image fully visible
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
