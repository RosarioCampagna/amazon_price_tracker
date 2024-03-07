import 'package:amazon_price_tracker/components/amazon_product_alert.dart';
import 'package:amazon_price_tracker/models/amazon_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';

class AmazonProductTile extends StatelessWidget {
  const AmazonProductTile({super.key, required this.product, required this.box});

  final AmazonProduct product;
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
            onTap: () => showDialog(context: context, builder: (context) => AmazonProductAlertWidget(product: product)),
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
            subtitle: Text(
                //se la spedizione del prodotto è null non mostrare nulla
                product.normalExpedition == 'null'
                    ? ''
                    //se la spedizione veloce è null mostra prezzo e spedizione normale
                    : product.fastExpedition == 'null'
                        ? '${product.productCostEuros},${product.productCostCents}€ Consegna ${product.normalExpedition}'

                        //se dice entro quanto ordinare mostra prezzo, spedizione normale e spedizione veloce entro un tot
                        : product.expeditionUntil != ''
                            ? '${product.productCostEuros},${product.productCostCents}€ Consegna ${product.normalExpedition}. ${product.expeditionUntil} con prime per riceverlo ${product.fastExpedition}'

                            //se no mostra prezzo, spedizione normale e spedizione veloce
                            : '${product.productCostEuros},${product.productCostCents}€ Consegna ${product.normalExpedition}. Ordina con prime per riceverlo ${product.fastExpedition}',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary)),

            //mostra la disponibilità del prodotto
            trailing: product.availability == 'Disponibilità immediata'

                // è in disponibilità immediata mostra una spunta verde
                ? Icon(Icons.check_circle_rounded, color: Colors.green.shade700)

                //se il prodotto non è disponibile mostra una spunta rossa
                : product.availability == 'Non disponibile.'
                    ? Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(color: Colors.red.shade700, shape: BoxShape.circle),
                        child: Icon(Icons.close_rounded, color: Theme.of(context).colorScheme.secondary, size: 18))

                    //se si riesce ad ottenere un numero di unità rimaste
                    : int.tryParse(product.availability) != null

                        //se è superiore a 5 mostra il numero in contenitore giallo
                        ? int.parse(product.availability) >= 5
                            ? Container(
                                width: 30,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.yellow.shade700),
                                child: Text(
                                  product.availability,
                                  style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.secondary),
                                  textAlign: TextAlign.center,
                                ))

                            //se è inferiore a 5 mostra il numero in contenitore rosso
                            : Container(
                                width: 30,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.orange.shade700),
                                child: Text(
                                  product.availability,
                                  style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.secondary),
                                  textAlign: TextAlign.center,
                                ))

                        //se non si ottiene un numero di unità rimaste mostra un contenitore con punto interrogativo
                        : Container(
                            padding: const EdgeInsets.all(1),
                            decoration:
                                BoxDecoration(color: Theme.of(context).colorScheme.tertiary, shape: BoxShape.circle),
                            child: Icon(Icons.question_mark_rounded,
                                color: Theme.of(context).colorScheme.secondary, size: 18))),
      ),
    );
  }
}
