import 'package:equatable/equatable.dart';

class ControlledPest extends Equatable {
  final String pestId;
  final String pestName;

  const ControlledPest({
    required this.pestId,
    required this.pestName,
  });

  @override
  List<Object> get props => [pestId, pestName];
}

class UsedChemical extends Equatable {
  final String chemicalId;
  final String chemicalName;
  final double quantity;
  final String unit;

  const UsedChemical({
    required this.chemicalId,
    required this.chemicalName,
    required this.quantity,
    required this.unit,
  });

  @override
  List<Object> get props => [chemicalId, chemicalName, quantity, unit];
}

class ServiceReport extends Equatable {
  final String id;
  final String visitId;
  final List<ControlledPest> controlledPests;
  final List<UsedChemical> usedChemicals;
  final DateTime createdAt;

  const ServiceReport({
    required this.id,
    required this.visitId,
    required this.controlledPests,
    required this.usedChemicals,
    required this.createdAt,
  });

  @override
  List<Object> get props => [
        id,
        visitId,
        controlledPests,
        usedChemicals,
        createdAt,
      ];
}

