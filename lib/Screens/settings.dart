import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'about_us.dart';

class SettingsScreen extends StatelessWidget {
  final RxBool receiveNotifications = false.obs;
  final RxBool receiveEmail = false.obs;
  final List<String> languages = ['English', 'Urdu'];
  final RxString selectedLanguage = 'English'.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'General Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
                  () => SwitchListTile(
                title: const Text('Notifications'),
                subtitle: const Text('Receive push notifications'),
                value: receiveNotifications.value,
                onChanged: (value) {
                  receiveNotifications.value = value;
                  // Handle onChanged logic here
                },
              ),
            ),
            const SizedBox(height: 16),
            Obx(
                  () => SwitchListTile(
                title: const Text('Email'),
                subtitle: const Text('Receive offers by email'),
                value: receiveEmail.value,
                onChanged: (value) {
                  receiveEmail.value = value;
                  // Handle onChanged logic here
                },
              ),
            ),
            const Divider(),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Language'),
              onTap: () {
                _showLanguageDialog(context);
              },
              subtitle: Obx(() => Text(selectedLanguage.value)),
            ),
            const Divider(),
            const Text(
              'About',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('About Us'),
              onTap: () {
                Get.to(const AboutUsScreen());
              },
            ),
            ListTile(
              title: const Text('Privacy Policy'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Terms and Conditions'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SingleChildScrollView(
            child: ListBody(
              children: languages.map((language) {
                return ListTile(
                  title: Text(language),
                  onTap: () {
                    selectedLanguage.value = language;
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
