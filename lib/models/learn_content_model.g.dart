// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learn_content_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LearnContentAdapter extends TypeAdapter<LearnContent> {
  @override
  final int typeId = 4;

  @override
  LearnContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LearnContent(
      id: fields[0] as String,
      question: fields[1] as String,
      answer: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LearnContent obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.question)
      ..writeByte(2)
      ..write(obj.answer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LearnContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
