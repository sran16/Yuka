import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';

class FavoritesProvider extends ChangeNotifier {
  List<Product> _favorites = [];
  static const String _boxName = 'favorites';
  static const String _favoritesKey = 'favorites_list';

  List<Product> get favorites => _favorites;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final box = await Hive.openBox(_boxName);
      final favoritesJson = box.get(_favoritesKey, defaultValue: <Map>[]);
      
      _favorites = favoritesJson
          .map((json) => Product.fromJson(Map<String, dynamic>.from(json)))
          .toList();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors du chargement des favoris: $e');
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final box = await Hive.openBox(_boxName);
      final favoritesJson = _favorites
          .map((product) => {
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
                'isFavorite': true,
              })
          .toList();
      
      await box.put(_favoritesKey, favoritesJson);
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde des favoris: $e');
    }
  }

  Future<void> toggleFavorite(Product product) async {
    final existingIndex = _favorites.indexWhere((p) => p.barcode == product.barcode);
    
    if (existingIndex != -1) {
      // Retirer des favoris
      _favorites.removeAt(existingIndex);
      product.isFavorite = false;
    } else {
      // Ajouter aux favoris
      product.isFavorite = true;
      _favorites.add(product);
    }
    
    await _saveFavorites();
    notifyListeners();
  }

  bool isFavorite(String barcode) {
    return _favorites.any((product) => product.barcode == barcode);
  }

  Future<void> removeFavorite(String barcode) async {
    _favorites.removeWhere((product) => product.barcode == barcode);
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> clearFavorites() async {
    _favorites.clear();
    await _saveFavorites();
    notifyListeners();
  }
} 