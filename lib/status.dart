import 'package:hive/hive.dart';

part 'status.g.dart';

@HiveType(typeId: 2)
enum DurationUnit {
  @HiveField(0, defaultValue: true)
  round,

  @HiveField(1)
  minute,

  @HiveField(2)
  hour
}

@HiveType(typeId: 1)
class Status extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int duration;

  @HiveField(2)
  DurationUnit durationUnit;

  Status({
    required this.name,
    required this.duration,
    required this.durationUnit,
  });
}
