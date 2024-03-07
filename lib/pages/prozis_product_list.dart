import 'package:amazon_price_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../apis/app_api.dart';
import '../components/prozis_product_tile.dart';

class ProzisProductList extends StatelessWidget {
  const ProzisProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(prozis).listenable(),
        builder: (context, prozisBox, widget) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: prozisBox.isEmpty
                  ? const Center(child: Text('Aggiungi un prodotto alla lista'))
                  : ListView.builder(
                      itemCount: prozisBox.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: FutureBuilder(
                              future: AppAPI().getProzisProduct(prozisBox.getAt(index)),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    const Expanded(
                                        child: Text('Impossibile visualizzare il prodotto in questo momento')),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => prozisBox.deleteAt(index),
                                    )
                                  ]);
                                }
                                return ProzisProductTile(product: snapshot.data!, box: prozisBox);
                              }),
                        );
                      }),
            ));
  }
}
