import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class IconDataAdapter extends TypeAdapter<IconData> {
  @override
  final typeId = 13; // Unique identifier for the adapter

  @override
  IconData read(BinaryReader reader) {
    final codePoint = reader.readInt();
    final fontFamily = reader.readString();
    final fontPackage = reader.readString();

    return IconData(
      codePoint,
      fontFamily: fontFamily,
      fontPackage: fontPackage,
    );
  }

  @override
  void write(BinaryWriter writer, IconData icon) {
    writer.writeInt(icon.codePoint);
    writer.writeString(icon.fontFamily??"");
    writer.writeString(icon.fontPackage??"");
  }
}
