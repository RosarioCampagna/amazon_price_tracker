class Product {
  String productName;
  String productCostEuros;
  String productCostCents;
  String imgURL;
  String availability;
  String productID;
  String normalExpedition;
  String fastExpedition;
  String expeditionUntil;

  Product(
      {required this.imgURL,
      required this.productName,
      required this.productCostEuros,
      required this.productCostCents,
      required this.availability,
      required this.productID,
      required this.normalExpedition,
      required this.fastExpedition,
      required this.expeditionUntil});
}
