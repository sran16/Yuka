import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/favorites_provider.dart';
import 'product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec image et note nutritionnelle
              Row(
                children: [
                  // Image du produit
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: product.imageUrl != null
                        ? Image.network(
                            product.imageUrl!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Informations du produit
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        if (product.brand != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            product.brand!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                        
                        const SizedBox(height: 8),
                        
                        // Note nutritionnelle
                        if (product.nutritionGrade != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: product.nutritionGradeColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              product.nutritionGrade!.name.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  // Bouton favori et flèche
                  Row(
                    children: [
                      Consumer<FavoritesProvider>(
                        builder: (context, favoritesProvider, child) {
                          final isFavorite = favoritesProvider.isFavorite(product.barcode);
                          return IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                              size: 20,
                            ),
                            onPressed: () {
                              favoritesProvider.toggleFavorite(product);
                            },
                          );
                        },
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Informations nutritionnelles rapides
              if (product.nutriments.isNotEmpty) ...[
                const Divider(),
                const SizedBox(height: 8),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNutrientInfo(
                      'Calories',
                      '${product.nutriments['energy-kcal_100g']?.toStringAsFixed(0) ?? '0'} kcal',
                    ),
                    _buildNutrientInfo(
                      'Lipides',
                      '${product.nutriments['fat_100g']?.toStringAsFixed(1) ?? '0'}g',
                    ),
                    _buildNutrientInfo(
                      'Glucides',
                      '${product.nutriments['carbohydrates_100g']?.toStringAsFixed(1) ?? '0'}g',
                    ),
                    _buildNutrientInfo(
                      'Protéines',
                      '${product.nutriments['proteins_100g']?.toStringAsFixed(1) ?? '0'}g',
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 8),
              
              // Allergènes
              if (product.allergens.isNotEmpty) ...[
                const Divider(),
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    const Icon(
                      Icons.warning_amber,
                      color: Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Allergènes: ${product.allergens.join(', ')}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientInfo(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
} 