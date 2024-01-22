// lib/screens/distance_screen.dart
// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:progresstrack/utils/distance_calculator.dart';

class DistanceScreen extends StatefulWidget {
  @override
  _DistanceScreenState createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<DistanceScreen> {
  DistanceCalculator distanceCalculator = DistanceCalculator();

  bool isMeasuring = false;
  double distance = 0.0;

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
        gyroscopeSum[0] += event.x;
        gyroscopeSum[1] += event.y;
        gyroscopeSum[2] += event.z;
      });
    });

    accelerometerEventStream().listen((AccelerometerEvent event) {
      setState(() {
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
      calculateDistance();
    });
  }

  void calculateDistance() {
    if (dataCount > 0) {
      double averageGyroX = gyroscopeSum[0] / dataCount;
      double averageGyroY = gyroscopeSum[1] / dataCount;
      double averageGyroZ = gyroscopeSum[2] / dataCount;

      double averageAccX = accelerometerSum[0] / dataCount;
      double averageAccY = accelerometerSum[1] / dataCount;
      double averageAccZ = accelerometerSum[2] / dataCount;

      // Wykorzystaj funkcję z DistanceCalculator w celu obliczenia dystansu
      distance = distanceCalculator.calculateDistance(
        averageGyroX,
        averageGyroY,
        averageGyroZ,
        averageAccX,
        averageAccY,
        averageAccZ,
      );

      distance = distance.abs(); // Upewnij się, że dystans jest dodatni
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Distance Measurement'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isMeasuring)
              ElevatedButton(
                onPressed: () {
                  startMeasuring();
                },
                child: Text('Start Measuring'),
              ),
            if (isMeasuring)
              ElevatedButton(
                onPressed: () {
                  stopMeasuring();
                  // Tutaj możesz wykorzystać obliczony dystans do dalszych działań,
                  // takich jak wyświetlenie wyniku użytkownikowi lub zapis do pamięci.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Dystans: $distance cm'),
                    ),
                  );
                },
                child: Text('Stop Measuring'),
              ),
          ],
        ),
      ),
    );
  }
}
