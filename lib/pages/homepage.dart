import 'package:amazon_price_tracker/apis/app_api.dart';
import 'package:amazon_price_tracker/components/add_alert.dart';
import 'package:amazon_price_tracker/components/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

      //tasto per aggiungere nuovi prodotti
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return const AddAlert();
              });
        },
        child: const Icon(Icons.add_rounded),
      ),
      appBar: AppBar(title: const Text('Lista di prodotti'), centerTitle: true),

      //listener per l'aggiunta di nuovi prodotti
      body: ValueListenableBuilder(
        valueListenable: Hive.box('products').listenable(),
        builder: (context, box, widget) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Center(
              child: box.isEmpty
                  ? const Center(child: Text('Aggiungi un prodotto per monitorarne il prezzo'))
                  : ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: FutureBuilder(
                              future: AppAPI().getProduct(box.getAt(index)),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Text(snapshot.error.toString()),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => Hive.box('products').deleteAt(index),
                                    )
                                  ]);
                                }
                                return ProductTile(product: snapshot.data!, box: box);
                              }),
                        );
                      })),
        ),
      ),
    );
  }
}
