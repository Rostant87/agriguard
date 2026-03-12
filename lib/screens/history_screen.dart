import 'package:flutter/material.dart';
import 'package:agriguard/services/db_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupération des scans via notre service DB
    final scans = DBService().getAllScans().reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique des Scans"),
        backgroundColor: Colors.green.shade100,
      ),
      body: scans.isEmpty
          ? const Center(child: Text("Aucun scan enregistré pour le moment."))
          : ListView.builder(
              itemCount: scans.length,
              itemBuilder: (context, index) {
                final scan = scans[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.history, color: Colors.green),
                    title: Text(scan['maladie'] ?? "Diagnostic inconnu"),
                    subtitle: Text(
                      "Lat: ${scan['latitude'].toStringAsFixed(4)} | Long: ${scan['longitude'].toStringAsFixed(4)}\nDate: ${scan['date'].substring(0, 16)}",
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
