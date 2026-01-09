import 'package:hive/hive.dart';
import '../../domain/entities/chemical.dart';

part 'chemical_model.g.dart';

@HiveType(typeId: 5)
class ChemicalModel extends Chemical {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String unit;

  const ChemicalModel({
    required this.id,
    required this.name,
    required this.unit,
  }) : super(
          id: id,
          name: name,
          unit: unit,
        );

  factory ChemicalModel.fromEntity(Chemical chemical) {
    return ChemicalModel(
      id: chemical.id,
      name: chemical.name,
      unit: chemical.unit,
    );
  }

  Chemical toEntity() {
    return Chemical(
      id: id,
      name: name,
      unit: unit,
    );
  }
}

