// lib/utils/calculator.dart
import 'dart:math';

class Calculator {
  double log10(double x) {
    return log(x) / log(10);
  }

  double calculateBMI(double weight, double heightInCentimeters) {
    // Convert height to meters
    double heightInMeters = heightInCentimeters / 100.0;

    // Calculate BMI using the new formula
    return weight / pow(heightInMeters, 2);
  }

  // Metoda do obliczania BMR dla mężczyzn
  double calculateBMRMale(double weight, double height, int age) {
    return 10 * weight + 6.25 * height - 5 * age + 5;
  }

  // Metoda do obliczania BMR dla kobiet
  double calculateBMRFemale(double weight, double height, int age) {
    return 10 * weight + 6.25 * height - 5 * age - 161;
  }

  // Updated method to calculate body fat for men
  double calculateBodyFatMale(double bmi, int age) {
    return (1.20 * bmi) + (0.23 * age) - 16.2;
  }

  // Zaktualizowana metoda do obliczania body fatu dla kobiet
  double calculateBodyFatFemale(double bmi, int age) {
    return (1.20 * bmi) + (0.23 * age) - 5.4;
  }

  // Metoda do obliczania FFMI
  double calculateFFMI(double weight, double height, double bodyFat) {
    double leanWeight = weight * (1 - bodyFat / 100);
    return leanWeight / pow(height, 2);
  }

  // Metoda do obliczania skorygowanego FFMI
  double calculateAdjustedFFMI(double ffmi, double height) {
    return ffmi + (6.1 * (1.8 - height));
  }
}
