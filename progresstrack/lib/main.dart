// lib/main.dart
// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:progresstrack/utils/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/menu_screen.dart';
import 'screens/user_info_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserPreferences.prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Progress Track',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserPreferences.prefs?.containsKey('name') == true
          ? const MenuScreen()
          : const UserInfoScreen(),
    );
  }
}
