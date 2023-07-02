
import 'package:hive/hive.dart';

import '../../domain/entities/account/account_entity.dart';

class PaymentTypeAdapter extends TypeAdapter<PaymentType> {
  @override
  final int typeId = 8; // Unique ID for the adapter

  @override
  PaymentType read(BinaryReader reader) {
    return PaymentType.values[reader.readInt()]; // Read the enum value using its index
  }

  @override
  void write(BinaryWriter writer, PaymentType obj) {
    writer.writeInt(obj.index); // Write the index of the enum value
  }
}