import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:amazon_price_tracker/models/amazon_product.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';

import '../models/prozis_product.dart';

class AppAPI {
  void addProduct(String text) {
    Hive.box('products').put(text, text);
  }

  Future<AmazonProduct> getAmazonProduct(String productID, String boxName) async {
    Uri url;

    //prendo in input il sito con il prodotto
    if (boxName == 'amazonMobile') {
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
      availability = availability.substring(availability.indexOf('solo') + 5, availability.indexOf('solo') + 7);
      availability = availability.trim();
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
      normalExpedition = normalExpedition.substring(normalExpedition.lastIndexOf('"') + 2);
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

    AmazonProduct product = AmazonProduct(
        imgURL: imgURL,
        productName: productName.trim(),
        productCostEuros: productCostEuros.trim(),
        productCostCents: productCostCents.trim(),
        availability: availability.trim(),
        productID: productID.trim(),
        normalExpedition: normalExpedition.trim(),
        fastExpedition: fastExpedition.trim(),
        expeditionUntil: expeditionUntil.trim());

    return product;
  }

  Future<ProzisProduct> getProzisProduct(String productID) async {
    Uri prozisURL = Uri.https('prozis.com', '/it/it/prozis/$productID');

    //ottengo la pagina di prozis
    Response prozisPage = await get(prozisURL);

    String body = prozisPage.body;

    //creo l'istanza soup della pagina
    BeautifulSoup prozisPageSoup = BeautifulSoup(body);

    //ottengo il nome del prodotto
    String productName = (prozisPageSoup.find('meta', attrs: {'property': 'og:title'})!['content']).toString();
    productName = productName.replaceAll('| Prozis', '');

    //ottengo la descrizione del prodotto
    String description = (prozisPageSoup.find('meta', attrs: {'property': 'og:description'})!['content']).toString();

    //ottengo l'url d'immagine del prodotto
    String imgURL = (prozisPageSoup.find('meta', attrs: {'property': 'og:image'})!['content']).toString();

    //ottengo il prezzo del prodotto
    String productPrice =
        (prozisPageSoup.find('meta', attrs: {'property': 'product:price:amount'})!['content']).toString();

    //ottengo i dettagli di spedizione del prodotto
    String shipping = prozisPageSoup.find('span', class_: 'freeshipping-style').toString();
    shipping = shipping.replaceAll('<span class="freeshipping-style">', '');
    shipping = shipping.replaceAll('</span>', '');

    return ProzisProduct(
        imgURL: imgURL,
        productName: productName,
        productDescription: description,
        productCost: productPrice,
        productShipping: shipping,
        productID: productID);
  }
}
