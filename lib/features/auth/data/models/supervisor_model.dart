import 'package:hive/hive.dart';
import '../../domain/entities/supervisor.dart';

part 'supervisor_model.g.dart';

@HiveType(typeId: 0)
class SupervisorModel extends Supervisor {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  const SupervisorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  }) : super(
          id: id,
          name: name,
          email: email,
          password: password,
        );

  factory SupervisorModel.fromEntity(Supervisor supervisor) {
    return SupervisorModel(
      id: supervisor.id,
      name: supervisor.name,
      email: supervisor.email,
      password: supervisor.password,
    );
  }

  Supervisor toEntity() {
    return Supervisor(
      id: id,
      name: name,
      email: email,
      password: password,
    );
  }
}

