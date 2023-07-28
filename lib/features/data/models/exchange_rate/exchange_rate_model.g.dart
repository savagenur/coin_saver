// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExchangeRateModelAdapter extends TypeAdapter<ExchangeRateModel> {
  @override
  final int typeId = 10;

  @override
  ExchangeRateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExchangeRateModel(
      base: fields[0] as String,
      rates: (fields[1] as List).cast<RateModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExchangeRateModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.base)
      ..writeByte(1)
      ..write(obj.rates);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExchangeRateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
