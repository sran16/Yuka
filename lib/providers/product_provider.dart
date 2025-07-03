import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  Product? _currentProduct;
  bool _isLoading = false;
  String? _error;

  Product? get currentProduct => _currentProduct;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Product> _searchResults = [];
  List<Product> get searchResults => _searchResults;

  Future<void> fetchProductByBarcode(String barcode) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 1) {
          _currentProduct = Product.fromJson(data['product']);
        } else {
          _error = 'Produit non trouvé';
          _currentProduct = null;
        }
      } else {
        _error = 'Erreur de connexion';
        _currentProduct = null;
      }
    } catch (e) {
      _error = 'Erreur: $e';
      _currentProduct = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearProduct() {
    _currentProduct = null;
    _error = null;
    notifyListeners();
  }

  Future<void> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      _searchResults.clear();
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://world.openfoodfacts.org/cgi/search.pl?search_terms=${Uri.encodeComponent(query)}&search_simple=1&action=process&json=1&page_size=20'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['products'] != null) {
          _searchResults = (data['products'] as List)
              .map((productJson) => Product.fromJson(productJson))
              .where((product) => product.name != 'Produit inconnu')
              .toList();
        } else {
          _searchResults = [];
        }
      } else {
        _error = 'Erreur de connexion';
        _searchResults = [];
      }
    } catch (e) {
      _error = 'Erreur: $e';
      _searchResults = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearSearchResults() {
    _searchResults.clear();
    notifyListeners();
  }
} 