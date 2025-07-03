import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scan_history_provider.dart';
import 'product_card.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScanHistoryProvider>(
      builder: (context, historyProvider, child) {
        if (historyProvider.scanHistory.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            // En-tête avec bouton pour vider l'historique
            _buildHeader(context, historyProvider),
            
            // Liste des produits
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: historyProvider.scanHistory.length,
                itemBuilder: (context, index) {
                  final product = historyProvider.scanHistory[index];
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
                      historyProvider.removeFromHistory(product.barcode);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} supprimé de l\'historique'),
                          action: SnackBarAction(
                            label: 'Annuler',
                            onPressed: () {
                              historyProvider.addToHistory(product);
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
            Icons.history,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'Aucun produit scanné',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Scannez votre premier produit pour commencer votre historique',
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

  Widget _buildHeader(BuildContext context, ScanHistoryProvider historyProvider) {
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
            Icons.history,
            color: Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(
            'Historique (${historyProvider.scanHistory.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (historyProvider.scanHistory.isNotEmpty)
            TextButton.icon(
              onPressed: () => _showClearHistoryDialog(context, historyProvider),
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

  void _showClearHistoryDialog(BuildContext context, ScanHistoryProvider historyProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vider l\'historique'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer tous les produits de votre historique ? Cette action ne peut pas être annulée.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              historyProvider.clearHistory();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Historique vidé'),
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