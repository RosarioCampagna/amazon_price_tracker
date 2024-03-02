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

  Product({
    required this.imgURL,
    required this.productName,
    required this.productCostEuros,
    required this.productCostCents,
    required this.availability,
  });
}
