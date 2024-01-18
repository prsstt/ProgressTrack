// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_final_fields, unused_field, unused_element

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserPreferences.prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class User {
  String name = '';
  String gender = '';
  int age = 0;
  double weight = 0;
  double height = 0;
  double waistCircumference = 0;
  double hipCircumference = 0;
  double neckCircumference = 0;
  String activityLevel = '';
}

class UserPreferences {
  static User user = User();
  static SharedPreferences? prefs;
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
              if (UserPreferences.user.gender.toLowerCase() == 'man') ...[
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

class GenderSpecificInfoScreen extends StatefulWidget {
  const GenderSpecificInfoScreen({Key? key});

  @override
  _GenderSpecificInfoScreenState createState() =>
      _GenderSpecificInfoScreenState();
}

class _GenderSpecificInfoScreenState extends State<GenderSpecificInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  bool showWaistField = false;
  bool showHipField = false;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    setState(() {
      UserPreferences.user.weight =
          UserPreferences.prefs!.getDouble('weight') ?? 0.0;
      UserPreferences.user.height =
          UserPreferences.prefs!.getDouble('height') ?? 0.0;
      UserPreferences.user.waistCircumference =
          UserPreferences.prefs!.getDouble('waistCircumference') ?? 0.0;
      UserPreferences.user.hipCircumference =
          UserPreferences.prefs!.getDouble('hipCircumference') ?? 0.0;
      UserPreferences.user.neckCircumference =
          UserPreferences.prefs!.getDouble('neckCircumference') ?? 0.0;
    });
  }

  void _saveUserPreferences() {
    UserPreferences.prefs!.setDouble('weight', UserPreferences.user.weight);
    UserPreferences.prefs!.setDouble('height', UserPreferences.user.height);
    UserPreferences.prefs!.setDouble(
        'waistCircumference', UserPreferences.user.waistCircumference);
    UserPreferences.prefs!
        .setDouble('hipCircumference', UserPreferences.user.hipCircumference);
    UserPreferences.prefs!
        .setDouble('neckCircumference', UserPreferences.user.neckCircumference);
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
    // TODO: implement build
    throw UnimplementedError();
  }
}

class Calculator {
  double log10(double x) {
    return log(x) / log10e;
  }

  // Metoda do obliczania BMI
  double calculateBMI(double weight, double height) {
    return weight / pow(height, 2);
  }

  // Metoda do obliczania BMR dla mężczyzn
  double calculateBMRMale(double weight, double height, int age) {
    return 10 * weight + 6.25 * height - 5 * age + 5;
  }

  // Metoda do obliczania BMR dla kobiet
  double calculateBMRFemale(double weight, double height, int age) {
    return 10 * weight + 6.25 * height - 5 * age - 161;
  }

  // Metoda do obliczania body fatu dla mężczyzn
  double calculateBodyFatMale(double waist, double height) {
    return log10(waist) / 0.74 - log10(height);
  }

  // Metoda do obliczania body fatu dla kobiet
  double calculateBodyFatFemale(
      double waist, double hip, double neck, double height) {
    return log10(waist) + log10(hip - neck) - 97.684 + log10(height) - 78.387;
  }

  // Metoda do obliczania FFMI
  double calculateFFMI(double weight, double height, double bodyFat) {
    return weight /
        ((1 + bodyFat / 100) / 2) /
        pow(height, 2) *
        2.20462 /
        (pow(1.0188 - height, 0.5));
  }

  // Metoda do obliczania skorygowanego FFMI
  double calculateAdjustedFFMI(double ffmi, double height) {
    return ffmi * (6.1 * (1 - 0.0188 - height));
  }
}

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
