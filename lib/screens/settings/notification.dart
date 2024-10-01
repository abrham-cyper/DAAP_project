import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool _financeNotificationsEnabled = false;
  bool _pushNotificationsEnabled = false;
  bool _smsNotificationsEnabled = false;

  // This method could be used to save settings to shared preferences or any state management solution.
  void _saveSettings() {
    // Save the settings logic here (e.g., using SharedPreferences)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _saveSettings();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings saved!')),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildNotificationSection('Finance Notifications', _financeNotificationsEnabled, (value) {
              setState(() {
                _financeNotificationsEnabled = value;
              });
            }),
            _buildNotificationSection('Push Notifications', _pushNotificationsEnabled, (value) {
              setState(() {
                _pushNotificationsEnabled = value;
              });
            }),
            _buildNotificationSection('SMS Notifications', _smsNotificationsEnabled, (value) {
              setState(() {
                _smsNotificationsEnabled = value;
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection(String title, bool value, ValueChanged<bool> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.deepPurple,
            ),
          ],
        ),
      ),
    );
  }
}
