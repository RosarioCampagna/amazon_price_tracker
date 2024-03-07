import 'package:amazon_price_tracker/models/prozis_product.dart';
import 'package:flutter/material.dart';

class ProzisProductAlertWidget extends StatelessWidget {
  const ProzisProductAlertWidget({
    super.key,
    required this.product,
  });

  final ProzisProduct product;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text(
        product.productName,
        style: const TextStyle(fontSize: 14),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(product.imgURL, height: 120),
            const SizedBox(height: 10),
            Text('${product.productCost}€', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Text(product.productDescription, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text(
              product.productShipping,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Indietro'))],
    );
  }
}
