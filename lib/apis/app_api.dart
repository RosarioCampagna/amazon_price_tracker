import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:bot_cazzeggio/models/product.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';

class AppAPI {
  void addProduct(String text) {
    Hive.box('products').put(text, text);
  }

  Future<List<Product>> getProductList(Box box) async {
    List<Product> productList = [];

    for (String productID in box.values) {
      //prendo in input il sito con il prodotto
      Uri url = Uri.https('amazon.it', '/gp/product/$productID');

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
      availability = availability.replaceAll('<span class="a-size-medium a-color-success"> ', '');
      availability = availability.replaceAll(' </span>', '');

      //cerca l'immagine del prodotto in questione
      String imgURL = soup.find('img', class_: 'a-dynamic-image').toString();
      imgURL = imgURL.substring(imgURL.indexOf('src="') + 5, imgURL.indexOf('" data-old'));

      //data di spedizione senza prime
      String normalExpedition =
          soup.find('*', id: 'mir-layout-DELIVERY_BLOCK-slot-PRIMARY_DELIVERY_MESSAGE_LARGE').toString();
      normalExpedition = normalExpedition.replaceAll(
          '<div class="a-spacing-base" id="mir-layout-DELIVERY_BLOCK-slot-PRIMARY_DELIVERY_MESSAGE_LARGE"><span data-csa-c-type="element" data-csa-c-content-id="DEXUnifiedCXPDM" data-csa-c-delivery-price="GRATUITA" data-csa-c-value-proposition="" data-csa-c-delivery-type="Consegna" data-csa-c-delivery-time="martedì, 5 marzo" data-csa-c-delivery-destination="" data-csa-c-delivery-condition="" data-csa-c-pickup-location="" data-csa-c-distance="" data-csa-c-delivery-cutoff="" data-csa-c-mir-view="CONSOLIDATED_CX" data-csa-c-mir-type="DELIVERY" data-csa-c-mir-sub-type="" data-csa-c-mir-variant="DEFAULT" data-csa-c-delivery-benefit-program-id="cfs"> <a class="a-link-normal" target="_blank" rel="noopener" href="/gp/help/customer/display.html?nodeId=200534000">Consegna GRATUITA</a> <span class="a-text-bold">',
          '');
      normalExpedition = normalExpedition.replaceAll(
          '</span>. <a class="a-link-normal" target="_blank" rel="noopener" href="/gp/help/customer/display.html/?nodeId=200534000">Maggiori informazioni</a> </span></div>',
          '');

      //data di spedizione con prime
      String fastExpedition =
          soup.find('*', id: 'mir-layout-DELIVERY_BLOCK-slot-SECONDARY_DELIVERY_MESSAGE_LARGE').toString();

      fastExpedition = fastExpedition.substring(fastExpedition.indexOf('data-csa-c-delivery-time="') + 26,
          fastExpedition.indexOf('" data-csa-c-delivery-destination=""'));

      //ordina entro
      String expeditionUntil =
          soup.find('*', id: 'mir-layout-DELIVERY_BLOCK-slot-SECONDARY_DELIVERY_MESSAGE_LARGE').toString();
      expeditionUntil = expeditionUntil.substring(expeditionUntil.indexOf('data-csa-c-delivery-cutoff="') + 28,
          expeditionUntil.indexOf('" data-csa-c-mir-view='));

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

      productList.add(product);
    }

    return productList;
  }
}
