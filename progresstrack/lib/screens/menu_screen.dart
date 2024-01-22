// lib/screens/menu_screen.dart
// ignore_for_file: unused_field, prefer_final_fields, library_private_types_in_public_api, prefer_const_constructors, unused_local_variable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:progresstrack/screens/user_info_screen.dart';
import 'package:progresstrack/utils/calculator.dart';
import 'package:progresstrack/utils/user_preferences.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentIndex = 0;
  bool showWelcomeMessage = true;

  // Results variables
  double bmiResult = 0.0;
  double ffmiResult = 0.0;
  double bmrResult = 0.0;
  double bodyFatResult = 0.0;

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

  void _calculateResults() {
    double weight = UserPreferences.user.weight;
    double height = UserPreferences.user.height;
    double waistCircumference = UserPreferences.user.waistCircumference;
    double hipCircumference = UserPreferences.user.hipCircumference;
    double neckCircumference = UserPreferences.user.neckCircumference;
    int age = UserPreferences.user.age;

    Calculator calculator = Calculator();

    setState(() {
      bmiResult = double.parse(
          calculator.calculateBMI(weight, height).toStringAsFixed(1));
      bmrResult = double.parse(UserPreferences.user.gender.toLowerCase() ==
              'man'
          ? calculator.calculateBMRMale(weight, height, age).toStringAsFixed(1)
          : calculator
              .calculateBMRFemale(weight, height, age)
              .toStringAsFixed(1));
      bodyFatResult = double.parse(UserPreferences.user.gender.toLowerCase() ==
              'man'
          ? calculator.calculateBodyFatMale(bmiResult, age).toStringAsFixed(1)
          : calculator
              .calculateBodyFatFemale(bmiResult, age)
              .toStringAsFixed(1));
      ffmiResult = double.parse(calculator
          .calculateFFMI(weight, height / 100, bodyFatResult)
          .toStringAsFixed(1));
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserInfoScreen(),
                  ),
                );
              },
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: showWelcomeMessage ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Text('Welcome $userName!'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _calculateResults();
              },
              child: Text('Calculate Results'),
            ),
            SizedBox(height: 20),
            if (bmiResult != 0.0)
              Column(
                children: [
                  Text('BMI: $bmiResult'),
                  Text('BMR: $bmrResult kcal'),
                  Text('Body Fat: $bodyFatResult%'),
                  Text('FFMI: $ffmiResult'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
