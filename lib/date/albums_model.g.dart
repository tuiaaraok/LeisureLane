// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'albums_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlbumsModelAdapter extends TypeAdapter<AlbumsModel> {
  @override
  final int typeId = 4;

  @override
  AlbumsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlbumsModel(
      albumsName: fields[0] as String,
      image: (fields[1] as List).cast<Uint8List>(),
    );
  }

  @override
  void write(BinaryWriter writer, AlbumsModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.albumsName)
      ..writeByte(1)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlbumsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
