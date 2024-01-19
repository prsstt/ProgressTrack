// lib/utils/calculator.dart
import 'dart:math';

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
