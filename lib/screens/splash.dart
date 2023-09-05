import 'package:flutter/material.dart';

// this screen will show if firebase is taking time to figure out if a user is logged in
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
      ),
      body: const Center(
        child: Text('Loading...'),
      ),
    );
  }
}
 