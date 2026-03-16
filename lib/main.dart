import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Importation de tes services
import 'package:agriguard/services/location_service.dart';
import 'package:agriguard/services/db_service.dart';
import 'package:agriguard/services/camera_service.dart';
import 'package:agriguard/services/tflite_service.dart'; // Import du service IA

// Importation de l'écran d'historique
import 'package:agriguard/screens/history_screen.dart';

// Instance globale pour accéder à l'IA partout dans l'app
final tfliteService = TFLiteService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialisation de la base de données Hive
  if (kIsWeb) {
    await Hive.initFlutter();
  } else {
    final directory = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(directory.path);
  }
  await Hive.openBox('agri_scans');

  // 2. Chargement du modèle IA au démarrage
  await tfliteService.loadModel();

  runApp(const AgriGuardApp());
}

class AgriGuardApp extends StatelessWidget {
  const AgriGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AgriGuard 🌿"),
        backgroundColor: Colors.green.shade100,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.eco, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              "AgriGuard : Protégez vos récoltes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // BOUTON SCANNER AVEC IA RÉELLE
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  // A. Prendre la photo
                  final photo = await CameraService().takePhoto();
                  if (photo == null) return;

                  // B. Lire les données de l'image
                  final imageData = await photo.readAsBytes();

                  // C. Lancer l'analyse avec TFLiteService
                  final resultatIA = await tfliteService.classifyImage(
                    imageData,
                  );

                  // D. Récupérer la position GPS
                  final position = await LocationService().getCurrentLocation();

                  // E. Sauvegarder le résultat réel
                  await DBService().saveScan(
                    resultatIA,
                    position.latitude,
                    position.longitude,
                  );

                  if (!context.mounted) return;

                  // F. Afficher le résultat dans une boîte de dialogue
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Résultat de l'analyse"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.psychology,
                            size: 50,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            resultatIA,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Erreur : $e"),
                      backgroundColor: Colors.green.shade300,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text("Scanner une plante"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
            ),

            const SizedBox(height: 15),

            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.list),
              label: const Text("Voir l'historique"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green,
                side: const BorderSide(color: Colors.green),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
