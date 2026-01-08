import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ClipOval(
          child: Image.asset(
            'assets/splash_image.png',
            width: 280,
            height: 280,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
