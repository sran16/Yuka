import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';

class ScanHistoryProvider extends ChangeNotifier {
  List<Product> _scanHistory = [];
  static const String _storageKey = 'scan_history';

  List<Product> get scanHistory => _scanHistory;

  ScanHistoryProvider() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_storageKey) ?? [];
      
      _scanHistory = historyJson
          .map((json) => Product.fromJson(jsonDecode(json)))
          .toList();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors du chargement de l\'historique: $e');
    }
  }

  Future<void> addToHistory(Product product) async {
    try {
      // Vérifier si le produit existe déjà
      final existingIndex = _scanHistory.indexWhere((p) => p.barcode == product.barcode);
      
      if (existingIndex != -1) {
        // Mettre à jour le produit existant
        _scanHistory[existingIndex] = product;
      } else {
        // Ajouter le nouveau produit au début
        _scanHistory.insert(0, product);
      }

      // Limiter l'historique à 50 produits
      if (_scanHistory.length > 50) {
        _scanHistory = _scanHistory.take(50).toList();
      }

      await _saveHistory();
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors de l\'ajout à l\'historique: $e');
    }
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = _scanHistory
          .map((product) => jsonEncode({
                'barcode': product.barcode,
                'product_name': product.name,
                'brands': product.brand,
                'image_url': product.imageUrl,
                'nutrition_grade_fr': product.nutritionGrade?.name,
                'ingredients_text_fr': product.ingredients.join(', '),
                'nutriments': product.nutriments,
                'allergens_tags': product.allergens,
                'nova_group': product.novaGroup,
                'ecoscore_grade': product.ecoscore,
              }))
          .toList();
      
      await prefs.setStringList(_storageKey, historyJson);
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde de l\'historique: $e');
    }
  }

  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      _scanHistory.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors de la suppression de l\'historique: $e');
    }
  }

  Future<void> removeFromHistory(String barcode) async {
    try {
      _scanHistory.removeWhere((product) => product.barcode == barcode);
      await _saveHistory();
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors de la suppression du produit: $e');
    }
  }
} 