import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String customerId;
  final String name;

  const Project({
    required this.id,
    required this.customerId,
    required this.name,
  });

  @override
  List<Object> get props => [id, customerId, name];
}

