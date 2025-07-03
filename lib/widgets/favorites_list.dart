import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import 'product_card.dart';

class FavoritesList extends StatelessWidget {
  const FavoritesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        if (favoritesProvider.favorites.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            // En-tête avec bouton pour vider les favoris
            _buildHeader(context, favoritesProvider),
            
            // Liste des favoris
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: favoritesProvider.favorites.length,
                itemBuilder: (context, index) {
                  final product = favoritesProvider.favorites[index];
                  return Dismissible(
                    key: Key(product.barcode),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      favoritesProvider.removeFavorite(product.barcode);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} retiré des favoris'),
                          action: SnackBarAction(
                            label: 'Annuler',
                            onPressed: () {
                              favoritesProvider.toggleFavorite(product);
                            },
                          ),
                        ),
                      );
                    },
                    child: ProductCard(product: product),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'Aucun favori',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Scannez des produits et ajoutez-les à vos favoris\nen cliquant sur le cœur ❤️',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, FavoritesProvider favoritesProvider) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          const SizedBox(width: 12),
          Text(
            'Mes Favoris (${favoritesProvider.favorites.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (favoritesProvider.favorites.isNotEmpty)
            TextButton.icon(
              onPressed: () => _showClearFavoritesDialog(context, favoritesProvider),
              icon: const Icon(Icons.clear_all, size: 18),
              label: const Text('Vider'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
        ],
      ),
    );
  }

  void _showClearFavoritesDialog(BuildContext context, FavoritesProvider favoritesProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vider les favoris'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer tous vos favoris ? Cette action ne peut pas être annulée.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              favoritesProvider.clearFavorites();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Favoris vidés'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Vider'),
          ),
        ],
      ),
    );
  }
} 