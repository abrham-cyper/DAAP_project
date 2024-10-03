import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent.withOpacity(0.8), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo or Image
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/Dereja-logo.png', // Update with your logo path
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Title
                const Text(
                  'Welcome to DAAP Finance Tracker',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),

                // Description
                const Text(
                  'At DAAP Finance Tracker, we strive to provide you with the best experience in managing your finances. Our goal is to empower you with the tools you need to make informed financial decisions.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),

                // Features Section
                const Text(
                  'Features:',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '• User-Friendly Interface\n'
                  '• Secure Authentication\n'
                  '• Real-Time Updates\n'
                  '• Cross-Platform Compatibility\n',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),

                // Team Section
                const Text(
                  'Meet Our Team:',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '• Alice Johnson - Project Manager\n'
                  '• Bob Smith - Lead Developer\n'
                  '• Clara Zhang - UI/UX Designer\n',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),

                // Contact Information
                const Text(
                  'Contact Us:',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Email: support@daapfinance.com\n'
                  'Phone: (123) 456-7890\n',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
