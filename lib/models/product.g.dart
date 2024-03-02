// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 1;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      imgURL: fields[3] as String,
      productName: fields[0] as String,
      productCostEuros: fields[1] as String,
      productCostCents: fields[2] as String,
      availability: fields[4] as String,
      productID: fields[5] as String,
      normalExpedition: fields[6] as String,
      fastExpedition: fields[7] as String,
      expeditionUntil: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.productName)
      ..writeByte(1)
      ..write(obj.productCostEuros)
      ..writeByte(2)
      ..write(obj.productCostCents)
      ..writeByte(3)
      ..write(obj.imgURL)
      ..writeByte(4)
      ..write(obj.availability)
      ..writeByte(5)
      ..write(obj.productID)
      ..writeByte(6)
      ..write(obj.normalExpedition)
      ..writeByte(7)
      ..write(obj.fastExpedition)
      ..writeByte(8)
      ..write(obj.expeditionUntil);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
