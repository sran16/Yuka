import 'package:flutter/material.dart';
import '../widgets/search_bar.dart';
import '../widgets/search_results.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recherche',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Barre de recherche
          const ProductSearchBar(),
          
          // Résultats de recherche
          const Expanded(
            child: SearchResults(),
          ),
        ],
      ),
    );
  }
} 