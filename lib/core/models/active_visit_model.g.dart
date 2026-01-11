// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_visit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActiveVisitModelAdapter extends TypeAdapter<ActiveVisitModel> {
  @override
  final int typeId = 10;

  @override
  ActiveVisitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActiveVisitModel(
      visitId: fields[0] as String,
      customerId: fields[1] as String,
      projectId: fields[2] as String,
      customerName: fields[3] as String,
      projectName: fields[4] as String,
      startTimeUtc: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ActiveVisitModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.visitId)
      ..writeByte(1)
      ..write(obj.customerId)
      ..writeByte(2)
      ..write(obj.projectId)
      ..writeByte(3)
      ..write(obj.customerName)
      ..writeByte(4)
      ..write(obj.projectName)
      ..writeByte(5)
      ..write(obj.startTimeUtc);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActiveVisitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
