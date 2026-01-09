// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisitModelAdapter extends TypeAdapter<VisitModel> {
  @override
  final int typeId = 6;

  @override
  VisitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VisitModel(
      id: fields[0] as String,
      supervisorId: fields[1] as String,
      customerId: fields[2] as String,
      projectId: fields[3] as String,
      date: fields[4] as DateTime,
      startTime: fields[5] as DateTime,
      endTime: fields[6] as DateTime?,
      teamMemberIds: (fields[7] as List).cast<String>(),
      serviceReportId: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VisitModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.supervisorId)
      ..writeByte(2)
      ..write(obj.customerId)
      ..writeByte(3)
      ..write(obj.projectId)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.startTime)
      ..writeByte(6)
      ..write(obj.endTime)
      ..writeByte(7)
      ..write(obj.teamMemberIds)
      ..writeByte(8)
      ..write(obj.serviceReportId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
