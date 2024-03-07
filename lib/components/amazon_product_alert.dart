import 'package:flutter/material.dart';
import '../models/amazon_product.dart';

class AmazonProductAlertWidget extends StatelessWidget {
  const AmazonProductAlertWidget({
    super.key,
    required this.product,
  });

  final AmazonProduct product;

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
            Text('${product.productCostEuros},${product.productCostCents}€',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            if ((product.availability != 'null' && int.tryParse(product.availability) != null))
              Text('Disponibilità: ${product.availability}', style: const TextStyle(fontSize: 20))
            else if (product.availability == 'Disponibilità immediata' || product.availability == 'Non disponibile.')
              Text(product.availability, style: const TextStyle(fontSize: 20))
            else
              const Text('Disponibilità sconosciuta', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text(
              //se la spedizione del prodotto è null non mostrare nulla
              product.normalExpedition == 'null'
                  ? ''
                  //se la spedizione veloce è null mostra prezzo e spedizione normale
                  : product.fastExpedition == 'null'
                      ? 'Consegna ${product.normalExpedition}'

                      //se dice entro quanto ordinare mostra prezzo, spedizione normale e spedizione veloce entro un tot
                      : product.expeditionUntil != ''
                          ? 'Consegna ${product.normalExpedition}. ${product.expeditionUntil} con prime per riceverlo ${product.fastExpedition}'

                          //se no mostra prezzo, spedizione normale e spedizione veloce
                          : 'Consegna ${product.normalExpedition}. Ordina con prime per riceverlo ${product.fastExpedition}',
              style: const TextStyle(fontSize: 16), textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Indietro'))],
    );
  }
}
