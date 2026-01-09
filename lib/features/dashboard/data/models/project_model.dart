import 'package:hive/hive.dart';
import '../../domain/entities/project.dart';

part 'project_model.g.dart';

@HiveType(typeId: 2)
class ProjectModel extends Project {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String customerId;

  @HiveField(2)
  final String name;

  const ProjectModel({
    required this.id,
    required this.customerId,
    required this.name,
  }) : super(
          id: id,
          customerId: customerId,
          name: name,
        );

  factory ProjectModel.fromEntity(Project project) {
    return ProjectModel(
      id: project.id,
      customerId: project.customerId,
      name: project.name,
    );
  }

  Project toEntity() {
    return Project(
      id: id,
      customerId: customerId,
      name: name,
    );
  }
}

