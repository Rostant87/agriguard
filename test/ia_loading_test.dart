import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

void main() {
  test('Vérification de la présence des fichiers IA', () {
    final modelExists = File('assets/models/model.tflite').existsSync();
    final labelsExist = File('assets/models/labels.txt').existsSync();

    expect(modelExists, true, reason: "Le fichier model.tflite est manquant dans assets/models/");
    expect(labelsExist, true, reason: "Le fichier labels.txt est manquant dans assets/models/");
  });
}
