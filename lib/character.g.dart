// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterAdapter extends TypeAdapter<Character> {
  @override
  final int typeId = 3;

  @override
  Character read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Character(
      fields[0] as int,
      fields[2] as String,
      fields[1] as int?,
    )
      ..enabled = fields[3] as bool
      ..statuses = (fields[4] as HiveList?)?.castHiveList();
  }

  @override
  void write(BinaryWriter writer, Character obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.initiativeBonus)
      ..writeByte(1)
      ..write(obj.initiativeScore)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.enabled)
      ..writeByte(4)
      ..write(obj.statuses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
