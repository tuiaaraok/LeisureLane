import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'plan_model.g.dart';

@HiveType(typeId: 1)
class PlanModel {
  @HiveField(0)
  String planeName;
  @HiveField(1)
  DateTime startDate;
  @HiveField(2)
  DateTime endDate;
  @HiveField(3)
  String description;
  @HiveField(4)
  List<StagesModel> stagesList;
  @HiveField(5)
  Uint8List? image;
  PlanModel(
      {required this.planeName,
      required this.startDate,
      required this.endDate,
      required this.description,
      required this.stagesList,
      required this.image});
}

@HiveType(typeId: 2)
class StagesModel {
  @HiveField(0)
  String stagesName;
  @HiveField(1)
  String startTime;
  StagesModel({required this.stagesName, required this.startTime});
}
