import 'dart:typed_data';
import 'package:flutter/services.dart'; // Pour charger le fichier texte
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TFLiteService {
  Interpreter? _interpreter;
  List<String>? _labels;

  // 1. Charger le modèle ET les labels
  Future<void> loadModel() async {
    try {
      // Chargement du modèle
      _interpreter = await Interpreter.fromAsset('assets/models/model.tflite');

      // Chargement des labels (le fichier texte)
      final labelsData = await rootBundle.loadString(
        'assets/models/labels.txt',
      );
      _labels = labelsData.split('\n').where((s) => s.isNotEmpty).toList();

      print("✅ Modèle et Labels (${_labels?.length}) chargés !");
    } catch (e) {
      print("❌ Erreur de chargement : $e");
    }
  }

  // 2. Classification
  Future<String> classifyImage(Uint8List imageData) async {
    if (_interpreter == null || _labels == null) return "IA non prête";

    try {
      final decodedImage = img.decodeImage(imageData);
      if (decodedImage == null) return "Image invalide";

      final resizedImage = img.copyResize(
        decodedImage,
        width: 224,
        height: 224,
      );
      var input = _imageToByteListFloat32(resizedImage, 224);

      // On prépare la sortie pour nos 4 classes (Cacao/Manioc)
      var output = List.filled(1 * 4, 0.0).reshape([1, 4]);

      // Lancer l'analyse
      _interpreter!.run(input, output);

      // Trouver l'index avec la probabilité la plus haute
      double maxScore = -1.0;
      int bestIndex = 0;
      for (int i = 0; i < output[0].length; i++) {
        if (output[0][i] > maxScore) {
          maxScore = output[0][i];
          bestIndex = i;
        }
      }

      // Retourner le nom de la maladie correspondant à l'index
      return _labels![bestIndex];
    } catch (e) {
      return "Erreur d'analyse : $e";
    }
  }

  Uint8List _imageToByteListFloat32(img.Image image, int inputSize) {
    var buffer = Float32List(1 * inputSize * inputSize * 3);
    var index = 0;
    for (var y = 0; y < inputSize; y++) {
      for (var x = 0; x < inputSize; x++) {
        var pixel = image.getPixel(x, y);
        buffer[index++] = (pixel.r / 255.0);
        buffer[index++] = (pixel.g / 255.0);
        buffer[index++] = (pixel.b / 255.0);
      }
    }
    return buffer.buffer.asUint8List();
  }
}
