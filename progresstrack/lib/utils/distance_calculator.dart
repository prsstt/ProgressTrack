// lib/utils/distance_calculator.dart
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class DistanceCalculator {
  double velocityX = 0.0, velocityY = 0.0, velocityZ = 0.0;
  double distanceX = 0.0, distanceY = 0.0, distanceZ = 0.0;
  double time = 0.0;

  // Parametry algorytmu
  double sensitivity = 0.01; // Czułość akcelerometru
  double timeInterval = 0.1; // Przeliczanie czasu na sekundy

  // Filtrowanie dolnoprzepustowe
  double alpha = 0.8;

  // Kontrola pomiarów
  bool measuring = false;

  void startMeasuring() {
    measuring = true;
    _startSensorListeners();
  }

  void stopMeasuring() {
    measuring = false;
  }

  void _startSensorListeners() {
    accelerometerEventStream(samplingPeriod: const Duration(milliseconds: 100))
        .listen((AccelerometerEvent event) {
      if (measuring) {
        _processAccelerometerData(event);
      }
    });
  }

  void _processAccelerometerData(AccelerometerEvent event) {
    // Filtrowanie dolnoprzepustowe
    double filteredX = alpha * velocityX + (1.0 - alpha) * event.x;
    double filteredY = alpha * velocityY + (1.0 - alpha) * event.y;
    double filteredZ = alpha * velocityZ + (1.0 - alpha) * event.z;

    // Obliczenia dla osi X
    distanceX = distanceX + velocityX * time + 0.5 * filteredX * time * time;
    velocityX = velocityX + filteredX * time;

    // Obliczenia dla osi Y
    distanceY = distanceY + velocityY * time + 0.5 * filteredY * time * time;
    velocityY = velocityY + filteredY * time;

    // Obliczenia dla osi Z
    distanceZ = distanceZ + velocityZ * time + 0.5 * filteredZ * time * time;
    velocityZ = velocityZ + filteredZ * time;
  }

  double getDistanceInCentimeters(double distanceInMeters) {
    return distanceInMeters * 100.0; // 1 metr = 100 centymetrów
  }

  double calculateDistance(
      double averageGyroX,
      double averageGyroY,
      double averageGyroZ,
      double averageAccX,
      double averageAccY,
      double averageAccZ) {}
}
