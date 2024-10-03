import 'package:flutter/material.dart';
import './Login.dart'; // Adjust this import to your actual Login page

class IntoScreen extends StatefulWidget {
  const IntoScreen({Key? key}) : super(key: key);

  @override
  State<IntoScreen> createState() => _IntoScreenState();
}

class _IntoScreenState extends State<IntoScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the login page after a delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoginPage()), // Adjust to your actual Login page class
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Text(
          'Hello Ab...',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
