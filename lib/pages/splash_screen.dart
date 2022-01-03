import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Align(
            alignment: Alignment(0, 0.9),
            child: CircularProgressIndicator(),
          ),
          Center(
            child: Image.asset(
              'resources/images/logo.png',
              width: 150,
            ),
          ),
        ],
      ),
    );
  }
}
