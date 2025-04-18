// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ideas_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IdeasModelAdapter extends TypeAdapter<IdeasModel> {
  @override
  final int typeId = 3;

  @override
  IdeasModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IdeasModel(
      nameIdeas: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, IdeasModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.nameIdeas);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdeasModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
