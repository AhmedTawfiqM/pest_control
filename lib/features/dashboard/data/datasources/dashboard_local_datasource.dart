import 'package:hive/hive.dart';
import '../models/customer_model.dart';
import '../models/project_model.dart';
import '../models/team_member_model.dart';

class DashboardLocalDataSource {
  final Box<CustomerModel> customerBox;
  final Box<ProjectModel> projectBox;
  final Box<TeamMemberModel> teamMemberBox;

  DashboardLocalDataSource({
    required this.customerBox,
    required this.projectBox,
    required this.teamMemberBox,
  });

  Future<List<CustomerModel>> getCustomers() async {
    return customerBox.values.toList();
  }

  Future<List<ProjectModel>> getProjectsByCustomerId(String customerId) async {
    return projectBox.values
        .where((project) => project.customerId == customerId)
        .toList();
  }

  Future<List<TeamMemberModel>> getTeamMembers() async {
    return teamMemberBox.values.toList();
  }
}

