// lib/screens/menu_screen.dart
// ignore_for_file: unused_field, prefer_final_fields, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:progresstrack/screens/user_info_screen.dart';
import 'package:progresstrack/utils/user_preferences.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentIndex = 0;
  bool showWelcomeMessage = true;
  bool showSettings = false;

  // Nowa kontroler formularza
  final _formKey = GlobalKey<FormState>();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _hideWelcomeMessage();
  }

  void _hideWelcomeMessage() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showWelcomeMessage = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String userName = UserPreferences.prefs?.getString('name') ?? 'Guest';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Tracker'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 162, 14, 199),
              ),
              child: Text('Progress Tracker'),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // Dodaj nawigację do UserInfoScreen po naciśnięciu przycisku
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserInfoScreen()),
                );
              },
            )
          ],
        ),
      ),
      body: Center(
        child: AnimatedOpacity(
          opacity: showWelcomeMessage ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome $userName!'),
            ],
            // Add your main content here
          ),
        ),
      ),
    );
  }
}
