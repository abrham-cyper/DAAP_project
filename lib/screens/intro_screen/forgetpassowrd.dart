import 'package:finance_tracker/screens/settings/change_profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController answerController = TextEditingController();
  String? securityQuestion;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSecurityQuestion();
  }

  Future<void> _loadSecurityQuestion() async {
    final prefs = await SharedPreferences.getInstance();
    securityQuestion = prefs.getString('securityQuestion');
    setState(() {});
  }

  Future<void> validateAnswer() async {
    final prefs = await SharedPreferences.getInstance();
    final storedAnswer = prefs.getString('securityAnswer');

    if (answerController.text.trim() == storedAnswer) {
      // Navigate to ChangeProfilePage if the answer is correct
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChangeProfile()),
      );
    } else {
      setState(() {
        errorMessage = 'Incorrect answer. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 10),
                Text(
                  securityQuestion ?? 'Loading security question...',
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: answerController,
                  decoration: InputDecoration(
                    labelText: 'Your Answer',
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: validateAnswer,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
