import 'package:hive/hive.dart';

import '../../domain/entities/account/account_entity.dart';

class OwnershipTypeAdapter extends TypeAdapter<OwnershipType> {
  @override
  final int typeId = 7; // Unique ID for the adapter

  @override
  OwnershipType read(BinaryReader reader) {
    return OwnershipType.values[reader.readInt()]; // Read the enum value using its index
  }

  @override
  void write(BinaryWriter writer, OwnershipType obj) {
    writer.writeInt(obj.index); // Write the index of the enum value
  }
}