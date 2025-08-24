// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuizBadgeAdapter extends TypeAdapter<QuizBadge> {
  @override
  final int typeId = 1;

  @override
  QuizBadge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizBadge(
      name: fields[0] as String,
      category: fields[1] as String,
      earned: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, QuizBadge obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.earned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizBadgeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
