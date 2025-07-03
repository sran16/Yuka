import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du produit'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec image et informations principales
            _buildHeader(),
            
            const SizedBox(height: 24),
            
            // Note nutritionnelle
            if (product.nutritionGrade != null) ...[
              _buildNutritionGrade(),
              const SizedBox(height: 24),
            ],
            
            // Informations nutritionnelles détaillées
            if (product.nutriments.isNotEmpty) ...[
              _buildNutritionSection(),
              const SizedBox(height: 24),
            ],
            
            // Liste des ingrédients
            if (product.ingredients.isNotEmpty) ...[
              _buildIngredientsSection(),
              const SizedBox(height: 24),
            ],
            
            // Allergènes
            if (product.allergens.isNotEmpty) ...[
              _buildAllergensSection(),
              const SizedBox(height: 24),
            ],
            
            // Informations supplémentaires
            _buildAdditionalInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image du produit
            if (product.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 64,
                      ),
                    );
                  },
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Nom du produit
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (product.brand != null) ...[
              const SizedBox(height: 8),
              Text(
                product.brand!,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            const SizedBox(height: 8),
            
            // Code-barres
            Text(
              'Code-barres: ${product.barcode}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionGrade() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Note nutritionnelle',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: product.nutritionGradeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      product.nutritionGrade!.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.nutritionGradeText,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getNutritionGradeDescription(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations nutritionnelles (pour 100g)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildNutrientRow('Énergie', '${product.nutriments['energy-kcal_100g']?.toStringAsFixed(0) ?? '0'} kcal'),
            _buildNutrientRow('Lipides', '${product.nutriments['fat_100g']?.toStringAsFixed(1) ?? '0'}g'),
            _buildNutrientRow('Dont acides gras saturés', '${product.nutriments['saturated-fat_100g']?.toStringAsFixed(1) ?? '0'}g'),
            _buildNutrientRow('Glucides', '${product.nutriments['carbohydrates_100g']?.toStringAsFixed(1) ?? '0'}g'),
            _buildNutrientRow('Dont sucres', '${product.nutriments['sugars_100g']?.toStringAsFixed(1) ?? '0'}g'),
            _buildNutrientRow('Fibres', '${product.nutriments['fiber_100g']?.toStringAsFixed(1) ?? '0'}g'),
            _buildNutrientRow('Protéines', '${product.nutriments['proteins_100g']?.toStringAsFixed(1) ?? '0'}g'),
            _buildNutrientRow('Sel', '${product.nutriments['salt_100g']?.toStringAsFixed(2) ?? '0'}g'),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Liste des ingrédients',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Text(
              product.ingredients.join(', '),
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergensSection() {
    return Card(
      elevation: 2,
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.warning_amber,
                  color: Colors.orange,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Allergènes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: product.allergens.map((allergen) {
                return Chip(
                  label: Text(allergen),
                  backgroundColor: Colors.orange[100],
                  labelStyle: const TextStyle(color: Colors.orange),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations supplémentaires',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            if (product.novaGroup != null)
              _buildInfoRow('NOVA Group', product.novaGroup!),
            
            if (product.ecoscore != null)
              _buildInfoRow('Éco-score', product.ecoscore!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getNutritionGradeDescription() {
    switch (product.nutritionGrade) {
      case NutritionGrade.a:
        return 'Excellent choix nutritionnel';
      case NutritionGrade.b:
        return 'Bon choix nutritionnel';
      case NutritionGrade.c:
        return 'Choix nutritionnel moyen';
      case NutritionGrade.d:
        return 'Choix nutritionnel médiocre';
      case NutritionGrade.e:
        return 'Choix nutritionnel à éviter';
      default:
        return 'Non évalué';
    }
  }
} 