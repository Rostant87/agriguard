# 🌿 AgriGuard : IA de Diagnostic Phytosanitaire pour les Zones Rurales

## 1. Introduction
AgriGuard est un projet conçu pour répondre aux défis de l'agriculture connectée au Cameroun. Cette application permet une détection précoce des maladies des plantes en utilisant l'intelligence artificielle directement sur le terminal mobile (Edge AI).

## 2. Objectifs du Projet
* **Accessibilité** : Fournir un outil gratuit aux agriculteurs n'ayant pas accès à des experts.
* **Autonomie** : Fonctionnement 100% hors-ligne (No-Cloud) pour les zones sans réseau.
* **Réaction rapide** : Réduire le temps entre la détection et le traitement.

## 3. Architecture du Système
L'application repose sur une architecture en couches (Layered Architecture) :
* **Couche Présentation** : Interface Flutter (Material 3).
* **Couche Logique** : Gestion des flux caméra et prétraitement d'image.
* **Couche Inférence** : Moteur TensorFlow Lite optimisé pour processeurs ARM.

## 4. Spécifications Techniques
| Composante | Technologie |
| :--- | :--- |
| **Framework** | Flutter (Dart) |
| **Moteur IA** | TensorFlow Lite (TFLite) |
| **Modèle** | MobileNetV2 / Inception (Entraîné sur pathologies locales) |
| **Stockage local** | SQLite / Hive (pour l'historique) |

## 5. Structure du Dépôt (Arborescence)
```text
lib/
├── main.dart             # Point d'entrée
├── screens/              # UI : Accueil, Caméra, Diagnostic
├── services/             # IA, Gestion Caméra, GPS
└── models/               # Classes de données
assets/
└── models/               # model.tflite & labels.txt
```

## 6. Installation et Configuration
### Prérequis
* Flutter SDK (dernière version stable)
* Un terminal Android (version 6.0 minimum)

### Étapes d'installation
1. Cloner le dépôt :
   `git clone https://github.com/Rostant87/agriguard.git`
2. Installer les dépendances :
   `flutter pub get`
3. Compiler et lancer :
   `flutter run`

## 7. Auteurs
* **Rostant** - Étudiant en 3ème année Cybersecurity, ICT University.
* **Équipe AgriGuard** - Promotion 2026.

