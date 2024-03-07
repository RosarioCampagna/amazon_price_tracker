import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../apis/app_api.dart';
import '../components/amazon_product_tile.dart';
import '../main.dart';

class AmazonProductList extends StatelessWidget {
  const AmazonProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(amazonDesktop).listenable(),
      builder: (context, amazonDesktopBox, widget) => ValueListenableBuilder(
        valueListenable: Hive.box(amazonMobile).listenable(),
        builder: (context, amazonMobileBox, widget) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            if (amazonDesktopBox.isEmpty)
              const Center(child: Text('Aggiungi un prodotto per monitorarne il prezzo'))
            else
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: amazonDesktop.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: FutureBuilder(
                            future: AppAPI().getAmazonProduct(amazonDesktopBox.getAt(index), 'amazonDesktop'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  const Expanded(child: Text('Impossibile visualizzare il prodotto in questo momento')),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => amazonDesktopBox.deleteAt(index),
                                  )
                                ]);
                              }
                              return AmazonProductTile(product: snapshot.data!, box: amazonDesktopBox);
                            }),
                      );
                    }),
              ),
            if (amazonMobileBox.isNotEmpty)
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: amazonMobile.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: FutureBuilder(
                          future: AppAPI().getAmazonProduct(amazonMobileBox.getAt(index), 'amazonMobile'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                const Expanded(child: Text('Impossibile visualizzare il prodotto in questo momento')),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => amazonMobileBox.deleteAt(index),
                                )
                              ]);
                            }
                            return AmazonProductTile(product: snapshot.data!, box: amazonDesktopBox);
                          }),
                    );
                  })
          ]),
        ),
      ),
    );
  }
}
