import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class IconDataAdapter extends TypeAdapter<IconData> {
  @override
  final typeId = 13; // Choose a unique ID for the adapter

  @override
  IconData read(BinaryReader reader) {
    int codePoint = reader.readInt();
    String fontFamily = reader.readString();
    return IconData(
      codePoint,
      fontFamily: fontFamily,
    );
  }

  @override
  void write(BinaryWriter writer, IconData icon) {
    writer.writeInt(icon.codePoint);
    writer.writeString(icon.fontFamily??"");
  }
}
