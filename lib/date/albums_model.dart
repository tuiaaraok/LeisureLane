import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'albums_model.g.dart';

@HiveType(typeId: 4)
class AlbumsModel {
  @HiveField(0)
  String albumsName;
  @HiveField(1)
  List<Uint8List> image;
  AlbumsModel({required this.albumsName, required this.image});
}
