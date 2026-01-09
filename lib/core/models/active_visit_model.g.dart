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
      customerId: fields[0] as String,
      projectId: fields[1] as String,
      customerName: fields[2] as String,
      projectName: fields[3] as String,
      startTimeUtc: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ActiveVisitModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.customerId)
      ..writeByte(1)
      ..write(obj.projectId)
      ..writeByte(2)
      ..write(obj.customerName)
      ..writeByte(3)
      ..write(obj.projectName)
      ..writeByte(4)
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
