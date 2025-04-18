import 'package:hive_flutter/hive_flutter.dart';
part 'ideas_model.g.dart';

@HiveType(typeId: 3)
class IdeasModel {
  @HiveField(1)
  String nameIdeas;
  IdeasModel({required this.nameIdeas});
}
