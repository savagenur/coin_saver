// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountModelAdapter extends TypeAdapter<AccountModel> {
  @override
  final int typeId = 0;

  @override
  AccountModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountModel(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as AccountType,
      paymentType: fields[20] as PaymentType?,
      balance: fields[3] as double,
      currency: fields[4] as CurrencyEntity,
      isPrimary: fields[5] as bool,
      isActive: fields[6] as bool,
      accountNumber: fields[7] as String?,
      institution: fields[8] as String?,
      ownershipType: fields[9] as OwnershipType,
      openingDate: fields[10] as DateTime,
      closingDate: fields[11] as DateTime?,
      interestRate: fields[12] as double?,
      creditLimit: fields[13] as double?,
      dueDate: fields[14] as int?,
      minimumBalance: fields[15] as double?,
      linkedAccounts: (fields[16] as List?)?.cast<String>(),
      notes: fields[17] as String?,
      transactionHistory: (fields[18] as List).cast<TransactionEntity>(),
      monthlyStatement: fields[19] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AccountModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.balance)
      ..writeByte(4)
      ..write(obj.currency)
      ..writeByte(5)
      ..write(obj.isPrimary)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.accountNumber)
      ..writeByte(8)
      ..write(obj.institution)
      ..writeByte(9)
      ..write(obj.ownershipType)
      ..writeByte(10)
      ..write(obj.openingDate)
      ..writeByte(11)
      ..write(obj.closingDate)
      ..writeByte(12)
      ..write(obj.interestRate)
      ..writeByte(13)
      ..write(obj.creditLimit)
      ..writeByte(14)
      ..write(obj.dueDate)
      ..writeByte(15)
      ..write(obj.minimumBalance)
      ..writeByte(16)
      ..write(obj.linkedAccounts)
      ..writeByte(17)
      ..write(obj.notes)
      ..writeByte(18)
      ..write(obj.transactionHistory)
      ..writeByte(19)
      ..write(obj.monthlyStatement)
      ..writeByte(20)
      ..write(obj.paymentType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
