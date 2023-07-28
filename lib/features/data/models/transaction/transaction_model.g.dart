// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 5;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      amount: fields[2] as double,
      category: fields[3] as CategoryModel,
      iconData: fields[21] as IconData,
      accountId: fields[5] as String,
      isIncome: fields[6] as bool,
      color: fields[20] as Color,
      isTransfer: fields[22] as bool?,
      description: fields[4] as String?,
      tags: (fields[7] as List?)?.cast<String>(),
      payee: fields[8] as String?,
      currency: fields[9] as String?,
      location: fields[10] as String?,
      receiptImage: fields[11] as String?,
      paymentMethod: fields[12] as String?,
      isRecurring: fields[13] as bool?,
      frequency: fields[14] as String?,
      reminderDate: fields[15] as DateTime?,
      isCleared: fields[16] as bool?,
      notes: fields[17] as String?,
      linkedTransactions: (fields[18] as List?)?.cast<String>(),
      isVoid: fields[19] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.accountId)
      ..writeByte(6)
      ..write(obj.isIncome)
      ..writeByte(7)
      ..write(obj.tags)
      ..writeByte(8)
      ..write(obj.payee)
      ..writeByte(9)
      ..write(obj.currency)
      ..writeByte(10)
      ..write(obj.location)
      ..writeByte(11)
      ..write(obj.receiptImage)
      ..writeByte(12)
      ..write(obj.paymentMethod)
      ..writeByte(13)
      ..write(obj.isRecurring)
      ..writeByte(14)
      ..write(obj.frequency)
      ..writeByte(15)
      ..write(obj.reminderDate)
      ..writeByte(16)
      ..write(obj.isCleared)
      ..writeByte(17)
      ..write(obj.notes)
      ..writeByte(18)
      ..write(obj.linkedTransactions)
      ..writeByte(19)
      ..write(obj.isVoid)
      ..writeByte(20)
      ..write(obj.color)
      ..writeByte(21)
      ..write(obj.iconData)
      ..writeByte(22)
      ..write(obj.isTransfer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
