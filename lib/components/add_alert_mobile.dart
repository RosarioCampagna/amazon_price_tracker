import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddAlertMobile extends StatelessWidget {
  const AddAlertMobile({super.key});
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
              tempText = text.substring(text.lastIndexOf('/') + 1);
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
