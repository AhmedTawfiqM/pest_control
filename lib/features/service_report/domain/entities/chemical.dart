import 'package:equatable/equatable.dart';

class Chemical extends Equatable {
  final String id;
  final String name;
  final String unit; // ml, g, drops

  const Chemical({
    required this.id,
    required this.name,
    required this.unit,
  });

  @override
  List<Object> get props => [id, name, unit];
}

