import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:bot_cazzeggio/components/product_tile.dart';
import 'package:bot_cazzeggio/models/product.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  //prendo in input il sito con il prodotto
  static Uri url = Uri.https('amazon.it', '/gp/product/B07W7LNTM5');

  //costruisco l'header
  static Map<String, String> headers = {
    'user-agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 Edg/122.0.0.0'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        child: const Icon(Icons.add_rounded),
      ),
      appBar: AppBar(title: const Text('Bot'), centerTitle: true),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('products').listenable(),
        builder: (box, child, widget) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
              child: FutureBuilder(
            future: get(url, headers: headers),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              //ottieni il body della richiesta html
              String response = snapshot.data!.body;

              //leggi la risposta in html e trasferiscila in questa variabile
              BeautifulSoup soup = BeautifulSoup(response);

              //cerca il nome del prodotto tramite soup e spezzettalo fino ad averne solo il nome
              String productName = soup.find('*', class_: 'a-size-large product-title-word-break').toString();
              productName = productName.replaceAll(
                  '<span id="productTitle" class="a-size-large product-title-word-break">        ', '');
              productName = productName.replaceAll('       </span>', '');

              //cerca il costo del prodotto parte intera tramite soup e spezzettalo fino ad averne solo il nome
              String productCostEuros = soup.find('*', class_: 'a-price-whole').toString();
              productCostEuros = productCostEuros.replaceAll('<span class="a-price-whole">', '');
              productCostEuros = productCostEuros.replaceAll('<span class="a-price-decimal">,</span></span>', '');

              //cerca il costo del prodotto parte decimale tramite soup e spezzettalo fino ad averne solo il nome
              String productCostCents = soup.find('*', class_: 'a-price-fraction').toString();
              productCostCents = productCostCents.replaceAll('<span class="a-price-fraction">', '');
              productCostCents = productCostCents.replaceAll('</span>', '');

              //cerca la disponibilità del prodotto tramite soup e spezzettalo fino ad averne solo il nome
              String availability = soup.find('*', class_: 'a-size-medium a-color-success').toString();
              availability = availability.replaceAll('<span class="a-size-medium a-color-success"> ', '');
              availability = availability.replaceAll(' </span>', '');

              //cerca l'immagine del prodotto in questione
              String imgURL = soup.find('img', class_: 'a-dynamic-image').toString();
              imgURL = imgURL.substring(imgURL.indexOf('src="') + 5, imgURL.indexOf('" data-old'));

              Product product = Product(
                  imgURL: imgURL,
                  productName: productName,
                  productCostEuros: productCostEuros,
                  productCostCents: productCostCents,
                  availability: availability);

              return ProductTile(product: product);
            },
          )),
        ),
      ),
    );
  }
}
