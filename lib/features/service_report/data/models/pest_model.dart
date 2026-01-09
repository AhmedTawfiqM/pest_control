import 'package:hive/hive.dart';
import '../../domain/entities/pest.dart';

part 'pest_model.g.dart';

@HiveType(typeId: 4)
class PestModel extends Pest {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  const PestModel({
    required this.id,
    required this.name,
  }) : super(
          id: id,
          name: name,
        );

  factory PestModel.fromEntity(Pest pest) {
    return PestModel(
      id: pest.id,
      name: pest.name,
    );
  }

  Pest toEntity() {
    return Pest(
      id: id,
      name: name,
    );
  }
}

