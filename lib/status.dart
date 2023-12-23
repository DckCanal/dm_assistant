enum DurationUnit { round, minute, hour }

class Status {
  String name;
  int duration;
  DurationUnit durationUnit;

  Status({
    required this.name,
    required this.duration,
    required this.durationUnit,
  });
}
