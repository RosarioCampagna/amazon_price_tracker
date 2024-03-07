import 'package:amazon_price_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddAlertNorm extends StatelessWidget {
  const AddAlertNorm({super.key});
  static String text = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Aggiungi il link del prodotto Amazon da tracciare'),
      content: TextField(
        onChanged: (value) => text = value,
        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        //tasto per tornare indietro
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              text = '';
            },
            child: const Text('Indietro')),

        const SizedBox(width: 10),

        //tasto per aggiungere un prodotto alla lista
        ElevatedButton(
          onPressed: () {
            if (text.isNotEmpty) {
              getProductID(text, context);
              text = '';
              Navigator.pop(context);
            }
          },
          child: const Text('Aggiungi'),
        ),
      ],
    );
  }
}

void getProductID(String value, BuildContext context) {
  bool productAdded = true;

  //aggiungi prodotto nella box amazon desktop
  if (value.contains('amazon')) {
    String tempText = value;
    try {
      tempText = value.substring(value.indexOf('dp') + 3, value.lastIndexOf('/'));
    } on Error {
      tempText = value.substring(value.indexOf('dp') + 3, value.lastIndexOf('dp') + 13);
    }
    if (tempText.length > 10) {
      tempText = value.substring(value.indexOf('product') + 8, value.indexOf('product') + 18);
    }
    if (!Hive.box(amazonDesktop).containsKey(tempText)) {
      Hive.box(amazonDesktop).put(tempText, tempText);
      return;
    } else {
      productAdded = false;
    }
  }

  //aggiungi prodotto nella box amazon mobile
  if (value.contains('amzn') && productAdded) {
    String productID = value.substring(value.lastIndexOf('/') + 1);
    if (!Hive.box(amazonMobile).containsKey(productID)) {
      Hive.box(amazonMobile).put(productID, productID);
      return;
    } else {
      productAdded = false;
    }
  }

  //aggiungi prodotto nella box prozis
  if (value.contains('prozis') && productAdded) {
    String productID = value.substring(value.lastIndexOf('/') + 1);
    if (!Hive.box(prozis).containsKey(productID)) {
      Hive.box(prozis).put(productID, productID);
      return;
    } else {
      productAdded = false;
    }
  }

  if (!productAdded) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('Prodotto già inserito'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Okay'))],
          );
        });
  }
}
