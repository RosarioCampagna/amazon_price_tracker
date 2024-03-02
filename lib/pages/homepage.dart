import 'package:bot_cazzeggio/apis/app_api.dart';
import 'package:bot_cazzeggio/components/add_alert.dart';
import 'package:bot_cazzeggio/components/product_tile.dart';
import 'package:bot_cazzeggio/models/product.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,

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
              child: FutureBuilder(
            future: AppAPI().getProductList(box),
            builder: (context, snapshot) {
              //se il future è in caricamento mostra progresso circolare
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              //se ha un errore mostra l'errore
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }

              //ottieni la lista di prodotti
              List<Product> productList = snapshot.data!;

              //se la lista è vuota mostra questo
              if (productList.isEmpty) {
                return const Center(child: Text('Nessun elemento aggiunto alla lista'));
              }

              //se no mostra la lista
              return ListView.builder(
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    //singolo prodotto ottenuto dalla lista
                    Product product = productList[index];

                    //in uscita product tile
                    return ProductTile(product: product, box: box);
                  });
            },
          )),
        ),
      ),
    );
  }
}
