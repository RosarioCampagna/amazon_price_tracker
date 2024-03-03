import 'dart:io';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:amazon_price_tracker/models/product.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';

class AppAPI {
  void addProduct(String text) {
    Hive.box('products').put(text, text);
  }

  Future<Product> getProductWeb(productID) async {
    Uri url;
    //prendo in input il sito con il prodotto
    if (Platform.isAndroid) {
      url = Uri.https('amzn.eu', '/d/$productID');
    } else {
      url = Uri.https('amazon.it', '/gp/product/$productID');
    }

    //costruisco l'header
    Map<String, String> headers = {
      'user-agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 Edg/122.0.0.0'
    };

    Response productFetch = await get(url, headers: headers);

    //ottieni il body della richiesta html
    String response = productFetch.body;

    //leggi la risposta in html e trasferiscila in questa variabile
    BeautifulSoup soup = BeautifulSoup(response);

    //cerca il nome del prodotto tramite soup e spezzettalo fino ad averne solo il nome
    String productName = soup.find('*', class_: 'a-size-large product-title-word-break').toString();
    productName =
        productName.replaceAll('<span id="productTitle" class="a-size-large product-title-word-break">        ', '');
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
    if (availability == 'null') {
      availability = soup.find('*', class_: 'a-size-base a-color-price a-text-bold').toString();
      availability =
          availability.replaceAll('<span class="a-size-base a-color-price a-text-bold"> Disponibilità: solo ', '');
      availability = availability.replaceAll(' </span>', '');
    } else {
      availability = availability.replaceAll('<span class="a-size-medium a-color-success"> ', '');
      availability = availability.replaceAll(' </span>', '');
    }
    //cerca l'immagine del prodotto in questione
    String imgURL = soup.find('img', class_: 'a-dynamic-image').toString();
    imgURL = imgURL.substring(imgURL.indexOf('http'), imgURL.indexOf('.jpg') + 4);

    String normalExpedition;
    String fastExpedition;
    String expeditionUntil;

    if (availability == '' || availability == 'Non disponibile.') {
      normalExpedition = 'null';
      fastExpedition = 'null';
      expeditionUntil = 'null';
    } else {
      //data di spedizione senza prime
      normalExpedition = soup.find('span', class_: 'a-text-bold').toString();
      normalExpedition = normalExpedition.replaceAll('<span class="a-text-bold">', '');
      normalExpedition = normalExpedition.replaceAll('</span>', '');

      //data di spedizione con prime
      fastExpedition = soup.find('*', id: 'mir-layout-DELIVERY_BLOCK-slot-SECONDARY_DELIVERY_MESSAGE_LARGE').toString();
      if (fastExpedition != 'null') {
        fastExpedition = fastExpedition.substring(fastExpedition.indexOf('data-csa-c-delivery-time="') + 26,
            fastExpedition.indexOf('" data-csa-c-delivery-destination=""'));
      }

      //ordina entro
      expeditionUntil =
          soup.find('*', id: 'mir-layout-DELIVERY_BLOCK-slot-SECONDARY_DELIVERY_MESSAGE_LARGE').toString();
      if (expeditionUntil != 'null') {
        expeditionUntil = expeditionUntil.substring(expeditionUntil.indexOf('data-csa-c-delivery-cutoff="') + 28,
            expeditionUntil.indexOf('" data-csa-c-mir-view='));
      }
    }

    Product product = Product(
        imgURL: imgURL,
        productName: productName,
        productCostEuros: productCostEuros,
        productCostCents: productCostCents,
        availability: availability,
        productID: productID,
        normalExpedition: normalExpedition,
        fastExpedition: fastExpedition,
        expeditionUntil: expeditionUntil);

    return product;
  }
}
