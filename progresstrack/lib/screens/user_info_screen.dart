// lib/screens/user_info_screen.dart
// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:progresstrack/screens/menu_screen.dart';
import 'package:progresstrack/utils/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _activityLevels = [
    'Little/no exercise',
    'Light exercise',
    'Moderate exercise (3-5 days/wk)',
    'Very active (6-7 days/wk)',
    'Extra active (very active & physical job)'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    UserPreferences.prefs = await SharedPreferences.getInstance();
    setState(() {
      UserPreferences.user.name =
          UserPreferences.prefs!.getString('name') ?? '';
      UserPreferences.user.gender =
          UserPreferences.prefs!.getString('gender') ?? '';
      UserPreferences.user.age = UserPreferences.prefs!.getInt('age') ?? 0;
      UserPreferences.user.activityLevel =
          UserPreferences.prefs!.getString('activityLevel') ?? '';
    });
  }

  void _saveUserPreferences() {
    UserPreferences.prefs!.setString('name', UserPreferences.user.name);
    UserPreferences.prefs!.setString('gender', UserPreferences.user.gender);
    UserPreferences.prefs!.setInt('age', UserPreferences.user.age);
    UserPreferences.prefs!
        .setString('activityLevel', UserPreferences.user.activityLevel);
  }

  void _navigateToNextScreen(BuildContext context) {
    _saveUserPreferences();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MenuScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) {
                  setState(() {
                    UserPreferences.user.name = value!;
                  });
                },
                initialValue: UserPreferences.user.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                items: ['Man', 'Woman'].map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    UserPreferences.user.gender = value.toString();
                  });
                },
                value: UserPreferences.user.gender.isNotEmpty
                    ? UserPreferences.user.gender
                    : 'Man',
                decoration: const InputDecoration(labelText: 'Gender'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  setState(() {
                    UserPreferences.user.age = int.tryParse(value!) ?? 0;
                  });
                },
                initialValue: UserPreferences.user.age.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                items: _activityLevels.map((level) {
                  return DropdownMenuItem(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    UserPreferences.user.activityLevel = value.toString();
                  });
                },
                value: UserPreferences.user.activityLevel.isNotEmpty
                    ? UserPreferences.user.activityLevel
                    : _activityLevels[0],
                decoration: const InputDecoration(labelText: 'Activity Level'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your activity level';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  setState(() {
                    UserPreferences.user.weight =
                        double.tryParse(value!) ?? 0.0;
                  });
                },
                initialValue: UserPreferences.user.weight.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  setState(() {
                    UserPreferences.user.height =
                        double.tryParse(value!) ?? 0.0;
                  });
                },
                initialValue: UserPreferences.user.height.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  return null;
                },
              ),
              if (UserPreferences.user.gender.toLowerCase() == 'man' ||
                  UserPreferences.user.gender.isEmpty) ...[
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Waist Circumference'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    setState(() {
                      UserPreferences.user.waistCircumference =
                          double.tryParse(value!) ?? 0.0;
                    });
                  },
                  initialValue:
                      UserPreferences.user.waistCircumference.toString(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your waist circumference';
                    }
                    return null;
                  },
                ),
              ] else if (UserPreferences.user.gender.toLowerCase() ==
                  'woman') ...[
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Hip Circumference'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    setState(() {
                      UserPreferences.user.hipCircumference =
                          double.tryParse(value!) ?? 0.0;
                    });
                  },
                  initialValue:
                      UserPreferences.user.hipCircumference.toString(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your hip circumference';
                    }
                    return null;
                  },
                ),
              ],
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Neck Circumference'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  setState(() {
                    UserPreferences.user.neckCircumference =
                        double.tryParse(value!) ?? 0.0;
                  });
                },
                initialValue: UserPreferences.user.neckCircumference.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your neck circumference';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _navigateToNextScreen(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
