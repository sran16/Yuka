# yuki

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


 Ce projet a été réalisé dans le but d’apprendre le développement d’applications mobiles avec Flutter et Dart.
 
 J’ai suivi une démarche itérative : recherche de solutions, expérimentation, correction des erreurs, et amélioration continue de l’interface et des fonctionnalités.

## Sources et inspirations
    
    - Documentation officielle Flutter : https://docs.flutter.dev/
    - Documentation Dart : https://dart.dev/guides
     - Tutoriels Flutter sur YouTube (ex : Flutter Explained)
     - OpenFoodFacts API pour la récupération des données produits
        - Packages utilisés :
        - simple_barcode_scanner
         - provider
         - hive
         - http
         - Forums et StackOverflow pour le débogage et les bonnes pratiques
     AR 
      - https://github.com/Unity-Technologies/arfoundation-samples 
      -  https://learn.unity.com/pathway/mobile-ar-development
      - https://github.com/PacktPublishing/XR-Development-with-Unity/tree/main/Chapter%2004
      
      Flutter 
      - https://pub.dev/packages/flutter_barcode_scanner/example
      - https://pub.dev/packages/openfoodfacts/example
      - https://wiki.openfoodfacts.org/API
      - https://github.com/openfoodfacts/openfoodfacts-react-native?tab=readme-ov-file
      - https://openfoodfacts.github.io/openfoodfacts-server/api/



2. Présentation de la conception de l’application
- L’application YUKI a été conçue pour offrir une expérience utilisateur simple, moderne et efficace, inspirée de l’application Yuka.

-  ### Architecture
 - Flutter pour le cross-platform (iOS/Android)
 - Provider pour la gestion d’état (produits, favoris, historique)
 - Hive pour le stockage local (favoris)
 - API OpenFoodFacts pour la base de données produits

> ### Structure
 - main.dart : point d’entrée, initialisation des providers
 - models/ : modèles de données (Product, etc.)
 - providers/ : gestion de l’état (produits, favoris, historique)
 - screens/ : écrans principaux (Accueil, Recherche, Historique, Favoris)
 - widgets/ : composants réutilisables (bouton scanner, carte produit, etc.)

 ### Fonctionnalités
 - Scanner de codes-barres (simple_barcode_scanner)
 - Recherche manuelle de produits
 - Affichage des informations nutritionnelles
 - Historique des scans
 - Système de favoris
 - Interface responsive et moderne