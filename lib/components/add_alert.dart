import 'package:bot_cazzeggio/models/product.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddAlert extends StatelessWidget {
  const AddAlert({super.key});
  static String text = '';
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Aggiungi il link del prodotto Amazon da tracciare'),
      content: TextField(
        onChanged: (value) => text = value
      ),
      actions: [ElevatedButton(onPressed: (){Hive.box('products').add(Product(imgURL: imgURL, productName: productName, productCostEuros: productCostEuros, productCostCents: productCostCents, availability: availability));}, child: child)],
    );
  }
}
