// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MainTransactionModelAdapter extends TypeAdapter<MainTransactionModel> {
  @override
  final int typeId = 4;

  @override
  MainTransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MainTransactionModel(
      id: fields[0] as String,
      name: fields[1] as String,
      iconData: fields[2] as IconData,
      color: fields[3] as Color,
      totalAmount: fields[4] as double,
      dateTime: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MainTransactionModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.iconData)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.totalAmount)
      ..writeByte(5)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainTransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
