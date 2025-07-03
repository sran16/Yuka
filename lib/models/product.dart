import 'package:flutter/material.dart';

class Product {
  final String barcode;
  final String name;
  final String? brand;
  final String? imageUrl;
  final NutritionGrade? nutritionGrade;
  final List<String> ingredients;
  final Map<String, double> nutriments;
  final List<String> allergens;
  final String? novaGroup;
  final String? ecoscore;
  bool isFavorite;

  Product({
    required this.barcode,
    required this.name,
    this.brand,
    this.imageUrl,
    this.nutritionGrade,
    required this.ingredients,
    required this.nutriments,
    required this.allergens,
    this.novaGroup,
    this.ecoscore,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      barcode: json['code']?.toString() ?? '',
      name: json['product_name']?.toString() ?? 'Produit inconnu',
      brand: json['brands']?.toString(),
      imageUrl: json['image_url']?.toString(),
      nutritionGrade: _parseNutritionGrade(json['nutrition_grade_fr']?.toString()),
      ingredients: _parseIngredients(json['ingredients_text_fr']?.toString() ?? json['ingredients_text']?.toString()),
      nutriments: _parseNutriments(json['nutriments']),
      allergens: _parseAllergens(json['allergens_tags']),
      novaGroup: json['nova_group']?.toString(),
      ecoscore: json['ecoscore_grade']?.toString(),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  static NutritionGrade? _parseNutritionGrade(String? grade) {
    if (grade == null) return null;
    switch (grade.toLowerCase()) {
      case 'a':
        return NutritionGrade.a;
      case 'b':
        return NutritionGrade.b;
      case 'c':
        return NutritionGrade.c;
      case 'd':
        return NutritionGrade.d;
      case 'e':
        return NutritionGrade.e;
      default:
        return null;
    }
  }

  static List<String> _parseIngredients(String? ingredientsText) {
    if (ingredientsText == null || ingredientsText.isEmpty) {
      return [];
    }
    return ingredientsText.split(',').map((e) => e.trim()).toList();
  }

  static Map<String, double> _parseNutriments(Map<String, dynamic>? nutriments) {
    if (nutriments == null) return {};
    
    final Map<String, double> result = {};
    final keys = ['energy-kcal_100g', 'fat_100g', 'saturated-fat_100g', 
                  'carbohydrates_100g', 'sugars_100g', 'fiber_100g', 
                  'proteins_100g', 'salt_100g'];
    
    for (String key in keys) {
      if (nutriments[key] != null) {
        result[key] = double.tryParse(nutriments[key].toString()) ?? 0.0;
      }
    }
    
    return result;
  }

  static List<String> _parseAllergens(List<dynamic>? allergensTags) {
    if (allergensTags == null) return [];
    return allergensTags.map((tag) => tag.toString().replaceAll('en:', '')).toList();
  }

  String get nutritionGradeText {
    switch (nutritionGrade) {
      case NutritionGrade.a:
        return 'A - Excellent';
      case NutritionGrade.b:
        return 'B - Bon';
      case NutritionGrade.c:
        return 'C - Moyen';
      case NutritionGrade.d:
        return 'D - Médiocre';
      case NutritionGrade.e:
        return 'E - Mauvais';
      default:
        return 'Non évalué';
    }
  }

  Color get nutritionGradeColor {
    switch (nutritionGrade) {
      case NutritionGrade.a:
        return Colors.green;
      case NutritionGrade.b:
        return Colors.lightGreen;
      case NutritionGrade.c:
        return Colors.orange;
      case NutritionGrade.d:
        return Colors.deepOrange;
      case NutritionGrade.e:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

enum NutritionGrade { a, b, c, d, e } 