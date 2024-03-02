import 'package:bot_cazzeggio/models/product.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      dense: true,
      visualDensity: const VisualDensity(vertical: 4),
      tileColor: Colors.grey.shade500,
      leading: ClipRRect(child: Image.network(product.imgURL)),
      title: Text(product.productName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          maxLines: 3,
          overflow: TextOverflow.ellipsis),
      subtitle: Text('${product.productCostEuros},${product.productCostCents}€',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: product.availability == 'Disponibilità immediata'
          ? Icon(Icons.check_circle_rounded, color: Colors.green.shade700)
          : Text(product.availability),
    );
  }
}
