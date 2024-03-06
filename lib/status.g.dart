// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatusAdapter extends TypeAdapter<Status> {
  @override
  final int typeId = 1;

  @override
  Status read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Status(
      name: fields[0] as String,
      duration: fields[1] as int,
      durationUnit: fields[2] as DurationUnit,
    );
  }

  @override
  void write(BinaryWriter writer, Status obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.duration)
      ..writeByte(2)
      ..write(obj.durationUnit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DurationUnitAdapter extends TypeAdapter<DurationUnit> {
  @override
  final int typeId = 2;

  @override
  DurationUnit read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DurationUnit.round;
      case 1:
        return DurationUnit.minute;
      case 2:
        return DurationUnit.hour;
      default:
        return DurationUnit.round;
    }
  }

  @override
  void write(BinaryWriter writer, DurationUnit obj) {
    switch (obj) {
      case DurationUnit.round:
        writer.writeByte(0);
        break;
      case DurationUnit.minute:
        writer.writeByte(1);
        break;
      case DurationUnit.hour:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DurationUnitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
