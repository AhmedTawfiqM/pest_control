// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_report_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ControlledPestModelAdapter extends TypeAdapter<ControlledPestModel> {
  @override
  final int typeId = 8;

  @override
  ControlledPestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ControlledPestModel(
      pestId: fields[0] as String,
      pestName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ControlledPestModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.pestId)
      ..writeByte(1)
      ..write(obj.pestName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ControlledPestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UsedChemicalModelAdapter extends TypeAdapter<UsedChemicalModel> {
  @override
  final int typeId = 9;

  @override
  UsedChemicalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UsedChemicalModel(
      chemicalId: fields[0] as String,
      chemicalName: fields[1] as String,
      quantity: fields[2] as double,
      unit: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UsedChemicalModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.chemicalId)
      ..writeByte(1)
      ..write(obj.chemicalName)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.unit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsedChemicalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ServiceReportModelAdapter extends TypeAdapter<ServiceReportModel> {
  @override
  final int typeId = 7;

  @override
  ServiceReportModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceReportModel(
      id: fields[0] as String,
      visitId: fields[1] as String,
      controlledPests: (fields[2] as List).cast<ControlledPestModel>(),
      usedChemicals: (fields[3] as List).cast<UsedChemicalModel>(),
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceReportModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.visitId)
      ..writeByte(2)
      ..write(obj.controlledPests)
      ..writeByte(3)
      ..write(obj.usedChemicals)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceReportModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
