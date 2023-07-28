// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RateModelAdapter extends TypeAdapter<RateModel> {
  @override
  final int typeId = 11;

  @override
  RateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RateModel(
      rateName: fields[0] as String,
      rate: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RateModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.rateName)
      ..writeByte(1)
      ..write(obj.rate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
