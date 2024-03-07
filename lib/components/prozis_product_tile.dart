import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';

import '../models/prozis_product.dart';
import 'prozis_product_alert.dart';

class ProzisProductTile extends StatelessWidget {
  const ProzisProductTile({super.key, required this.product, required this.box});

  final ProzisProduct product;
  final Box box;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),

      //pannello scorrevole per l'eliminazione del tile
      child: Slidable(
          endActionPane: ActionPane(extentRatio: 0.2, motion: const ScrollMotion(), children: [
            //tasto di eliminazione del prodotto
            SlidableAction(
              onPressed: (context) {
                box.delete(product.productID);
              },
              icon: Icons.delete_rounded,
              backgroundColor: Colors.red.shade700,
              borderRadius: BorderRadius.circular(12),
            )
          ]),
          //list tile del prodotto
          child: ListTile(
            onTap: () => showDialog(context: context, builder: (context) => ProzisProductAlertWidget(product: product)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            dense: true,
            visualDensity: const VisualDensity(vertical: 4),
            tileColor: Theme.of(context).colorScheme.secondary,
            leading: Image.network(product.imgURL, width: 100),

            //nome del prodotto, se in overflow mostra 3 puntini alla fine
            title: Text(product.productName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                maxLines: 3,
                overflow: TextOverflow.ellipsis),

            //spedizione del prodotto
            subtitle: Text(product.productShipping,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary)),
            trailing: Text('${product.productCost}€', style: TextStyle(fontSize: 20)),
          )),
    );
  }
}
