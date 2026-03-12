import 'package:hive/hive.dart';

class DBService {
  // Accès à la boîte de stockage initialisée dans le main.dart
  final _box = Hive.box('agri_scans');

  // Sauvegarde un diagnostic (Même sans internet)
  Future<void> saveScan(String maladie, double lat, double long) async {
    await _box.add({
      'maladie': maladie,
      'latitude': lat,
      'longitude': long,
      'date': DateTime.now().toIso8601String(),
    });
  }

  // Récupérer tout l'historique local
  List getAllScans() {
    return _box.values.toList();
  }
}
