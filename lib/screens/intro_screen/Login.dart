import 'package:finance_tracker/screens/intro_screen/forgetpassowrd.dart';
import 'package:finance_tracker/screens/intro_screen/regestor.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import '../home/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool authenticated = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final LocalAuthentication _localAuth = LocalAuthentication();
  String? errorMessage;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkAndSaveDefaultCredentials();
    _checkAndAuthenticate(); // Check biometric authentication
  }

  Future<void> _checkAndSaveDefaultCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    final storedPassword = prefs.getString('password');

    if (storedUsername == null || storedPassword == null) {
      await prefs.setString('username', 'admin');
      await prefs.setString('password', 'admin@321');
    }
  }

  Future<void> _checkAndAuthenticate() async {
    // Biometric authentication logic here
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        setState(() {
          authenticated = true;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Login failed. Please try again.';
      });
    }
  }

  Future<void> loginWithUsernameAndPassword() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Please enter your username and password.';
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    final storedPassword = prefs.getString('password');

    if (username == storedUsername && password == storedPassword) {
      setState(() {
        authenticated = true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      setState(() {
        errorMessage = 'Invalid username or password.';
      });
    }
  }

  Future<void> Regestor() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => HomeScreen()));
  }

  Future<void> forgetpassword() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => ForgotPasswordPage()));
  }

  @override
  Widget build(BuildContext context) {
    if (authenticated) {
      return HomeScreen(); // Redirect to home screen if authenticated
    } else {
      return Scaffold(
          body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/1.png'), // Update the path as necessary
            fit: BoxFit.cover, // This makes the image cover the whole container
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                      height: 370), // Adjust this value to push down further
                  Container(
                    width: 280, // Fixed width for the card
                    height: 350, // Fixed height for the card
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                      ),
                      color: Colors.white.withOpacity(0.8), // Transparent card
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0, // Consistent vertical padding
                          horizontal: 15.0,
                        ),
                        child: Column(
                          children: [
                            if (errorMessage != null)
                              Text(
                                errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Rounded borders
                                  borderSide: BorderSide.none, // No border
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(
                                    0.5), // Slightly transparent background
                                prefixIcon: const Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Rounded borders
                                  borderSide: BorderSide.none, // No border
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(
                                    0.5), // Slightly transparent background
                                prefixIcon: const Icon(Icons.lock),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                minimumSize:
                                    const Size(120, 40), // Smaller button size
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: loginWithUsernameAndPassword,
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.white60),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                minimumSize:
                                    const Size(120, 40), // Smaller button size
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          RegisterPage()), // Correctly navigate to RegisterPage
                                );
                              },
                              child: const Text(
                                'Register', // Fixed typo: 'Regestore' to 'Register'
                                style: TextStyle(color: Colors.white60),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Forgot Password functionality not implemented.'),
                                  ),
                                );
                              },
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ForgotPasswordPage()),
                                  );
                                },
                                child: const Text('Forgot Password?'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }
  }
}
