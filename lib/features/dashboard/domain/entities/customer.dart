import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String id;
  final String name;
  final List<String> projectIds;

  const Customer({
    required this.id,
    required this.name,
    required this.projectIds,
  });

  @override
  List<Object> get props => [id, name, projectIds];
}

