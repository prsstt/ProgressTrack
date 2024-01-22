// lib/screens/body_measurement.dart
// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class BodyMeasurement extends StatefulWidget {
  @override
  _BodyMeasurementState createState() => _BodyMeasurementState();
}

class _BodyMeasurementState extends State<BodyMeasurement> {
  bool isMeasuring = false;
  List<double> gyroscopeValues = [0, 0, 0];
  List<double> accelerometerValues = [0, 0, 0];
  double circumference = 0.0;

  List<double> gyroscopeSum = [0, 0, 0];
  List<double> accelerometerSum = [0, 0, 0];
  int dataCount = 0;

  @override
  void initState() {
    super.initState();
  }

  void startMeasuring() {
    gyroscopeEventStream().listen((GyroscopeEvent event) {
      setState(() {
        gyroscopeValues = [event.x, event.y, event.z];
        gyroscopeSum[0] += event.x;
        gyroscopeSum[1] += event.y;
        gyroscopeSum[2] += event.z;
      });
    });

    accelerometerEventStream().listen((AccelerometerEvent event) {
      setState(() {
        accelerometerValues = [event.x, event.y, event.z];
        accelerometerSum[0] += event.x;
        accelerometerSum[1] += event.y;
        accelerometerSum[2] += event.z;
        dataCount++;
      });
    });

    setState(() {
      isMeasuring = true;
    });
  }

  void stopMeasuring() {
    setState(() {
      isMeasuring = false;
      calculateCircumference();
    });
  }

  void calculateCircumference() {
    if (dataCount > 0) {
      double averageGyroX = gyroscopeSum[0] / dataCount;
      double averageGyroY = gyroscopeSum[1] / dataCount;
      double averageGyroZ = gyroscopeSum[2] / dataCount;

      double averageAccX = accelerometerSum[0] / dataCount;
      double averageAccY = accelerometerSum[1] / dataCount;
      double averageAccZ = accelerometerSum[2] / dataCount;

      // Tutaj umieść algorytm do obliczania obwodu na podstawie odczytów z sensorów
      // Przykładowo, możesz użyć prostego algorytmu śledzenia ruchu.

      // Poniżej znajdziesz przykładowy sposób obliczania obwodu jako średniej z wartości z sensorów.
      // Wartość ta jest tylko przykładem i może wymagać kalibracji oraz dostosowania do rzeczywistych danych.
      circumference = (averageGyroX +
              averageGyroY +
              averageGyroZ +
              averageAccX +
              averageAccY +
              averageAccZ) /
          6;
      circumference = circumference.abs(); // Upewnij się, że obwód jest dodatni
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Body Measurement'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isMeasuring)
              ElevatedButton(
                onPressed: () {
                  // Wyświetl instrukcję
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Instruction'),
                        content: Text(
                          'Hold the "Measure Body" button and move your phone around your neck. Release the button when you are done.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              startMeasuring();
                            },
                            child: Text('Start Measuring'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Measure Body'),
              ),
            if (isMeasuring)
              ElevatedButton(
                onPressed: () {
                  stopMeasuring();
                  // Tutaj możesz wykorzystać obliczony obwód do dalszych działań,
                  // takich jak wyświetlenie wyniku użytkownikowi lub zapis do pamięci.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Obwód: $circumference cm'),
                    ),
                  );
                },
                child: Text('Stop Measuring'),
              ),
            if (isMeasuring) Text('Gyroscope Values: $gyroscopeValues'),
            if (isMeasuring) Text('Accelerometer Values: $accelerometerValues'),
          ],
        ),
      ),
    );
  }
}
