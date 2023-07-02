
import 'package:hive/hive.dart';

import '../../domain/entities/account/account_entity.dart';

class AccountTypeAdapter extends TypeAdapter<AccountType> {
  @override
  final int typeId = 6; // Unique ID for the adapter

  @override
  AccountType read(BinaryReader reader) {
    return AccountType.values[reader.readInt()]; // Read the enum value using its index
  }

  @override
  void write(BinaryWriter writer, AccountType obj) {
    writer.writeInt(obj.index); // Write the index of the enum value
  }
}