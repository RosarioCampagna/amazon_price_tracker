import 'package:hive/hive.dart';
part 'product.g.dart';

@HiveType(typeId: 1)
class Product {
  @HiveField(0)
  String productName;
  @HiveField(1)
  String productCostEuros;
  @HiveField(2)
  String productCostCents;
  @HiveField(3)
  String imgURL;
  @HiveField(4)
  String availability;
  @HiveField(5)
  String productID;
  @HiveField(6)
  String normalExpedition;
  @HiveField(7)
  String fastExpedition;
  @HiveField(8)
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
