import 'package:hive/hive.dart';
import '../../domain/entities/customer.dart';

part 'customer_model.g.dart';

@HiveType(typeId: 1)
class CustomerModel extends Customer {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<String> projectIds;

  const CustomerModel({
    required this.id,
    required this.name,
    required this.projectIds,
  }) : super(
          id: id,
          name: name,
          projectIds: projectIds,
        );

  factory CustomerModel.fromEntity(Customer customer) {
    return CustomerModel(
      id: customer.id,
      name: customer.name,
      projectIds: customer.projectIds,
    );
  }

  Customer toEntity() {
    return Customer(
      id: id,
      name: name,
      projectIds: projectIds,
    );
  }
}

