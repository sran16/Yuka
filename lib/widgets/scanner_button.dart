import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../providers/product_provider.dart';
import '../providers/scan_history_provider.dart';

class ScannerButton extends StatelessWidget {
  const ScannerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () => _scanBarcode(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, size: 24),
            SizedBox(width: 12),
            Text(
              'Scanner un code-barres',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scanBarcode(BuildContext context) async {
    try {
      final String? result = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Annuler',
        true,
        ScanMode.BARCODE,
      );

      if (result != null && result.isNotEmpty) {
        // Récupérer les providers
        final productProvider = Provider.of<ProductProvider>(context, listen: false);
        final historyProvider = Provider.of<ScanHistoryProvider>(context, listen: false);

        // Chercher le produit
        await productProvider.fetchProductByBarcode(result);

        // Si le produit est trouvé, l'ajouter à l'historique
        if (productProvider.currentProduct != null) {
          await historyProvider.addToHistory(productProvider.currentProduct!);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du scan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} 