import 'package:bot_cazzeggio/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product, required this.box});

  final Product product;
  final Box box;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: Slidable(
        endActionPane: ActionPane(motion: const ScrollMotion(), children: [
          SlidableAction(
            onPressed: (context) {
              box.delete(product.productID);
            },
            label: 'Elimina',
            icon: Icons.delete_rounded,
            backgroundColor: Colors.red.shade700,
            borderRadius: BorderRadius.circular(12),
          )
        ]),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          dense: true,
          visualDensity: const VisualDensity(vertical: 4),
          tileColor: Colors.grey.shade500,
          leading: ClipRRect(child: Image.network(product.imgURL)),
          title: Text(product.productName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              maxLines: 3,
              overflow: TextOverflow.ellipsis),
          subtitle: Text(
              '${product.productCostEuros},${product.productCostCents}€ ${product.normalExpedition}, Oppure ${product.expeditionUntil} con prime per riceverlo ${product.fastExpedition}',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          trailing: product.availability == 'Disponibilità immediata'
              ? Icon(Icons.check_circle_rounded, color: Colors.green.shade700)
              : Text(product.availability),
        ),
      ),
    );
  }
}
