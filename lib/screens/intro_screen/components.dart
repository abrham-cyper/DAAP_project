import 'package:flutter/material.dart';
import 'Login.dart'; // Ensure this points to your home_page.dart

class IntoScreen extends StatefulWidget {
  const IntoScreen({Key? key}) : super(key: key);

  @override
  State<IntoScreen> createState() => _IntoScreenState();
}

class _IntoScreenState extends State<IntoScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to home page after a delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoginPage()), // Adjust this to your actual HomePage class
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Hello World',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
