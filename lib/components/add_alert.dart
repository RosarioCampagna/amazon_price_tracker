import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddAlert extends StatelessWidget {
  const AddAlert({super.key});
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
              String tempText = text;
              try {
                tempText = text.substring(text.indexOf('dp') + 3, text.lastIndexOf('/'));
              } on Error {
                tempText = text.substring(text.indexOf('dp') + 3, text.lastIndexOf('dp') + 13);
              }
              if (tempText.length > 10) {
                tempText = text.substring(text.indexOf('product') + 8, text.indexOf('product') + 18);
              }
              if (!Hive.box('products').containsKey(tempText)) {
                Hive.box('products').put(tempText, tempText);
                tempText = '';
                text = '';
                Navigator.pop(context);
              } else {
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
          },
          child: const Text('Aggiungi'),
        ),
      ],
    );
  }
}
