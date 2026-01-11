import 'package:hive_flutter/hive_flutter.dart';
import '../../features/auth/data/models/supervisor_model.dart';
import '../../features/dashboard/data/models/customer_model.dart';
import '../../features/dashboard/data/models/project_model.dart';
import '../../features/dashboard/data/models/team_member_model.dart';
import '../../features/service_report/data/models/chemical_model.dart';
import '../../features/service_report/data/models/pest_model.dart';
import '../../features/service_report/data/models/service_report_model.dart';
import '../../features/visits/data/models/visit_model.dart';
import '../constants/app_constants.dart';
import '../models/active_visit_model.dart';

class DatabaseService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(SupervisorModelAdapter());
    Hive.registerAdapter(CustomerModelAdapter());
    Hive.registerAdapter(ProjectModelAdapter());
    Hive.registerAdapter(TeamMemberModelAdapter());
    Hive.registerAdapter(PestModelAdapter());
    Hive.registerAdapter(ChemicalModelAdapter());
    Hive.registerAdapter(VisitModelAdapter());
    Hive.registerAdapter(ServiceReportModelAdapter());
    Hive.registerAdapter(ControlledPestModelAdapter());
    Hive.registerAdapter(UsedChemicalModelAdapter());
    Hive.registerAdapter(ActiveVisitModelAdapter());

    // Open boxes
    await Hive.openBox<SupervisorModel>(AppConstants.supervisorBox);
    await Hive.openBox<CustomerModel>(AppConstants.customerBox);
    await Hive.openBox<ProjectModel>(AppConstants.projectBox);
    await Hive.openBox<TeamMemberModel>(AppConstants.teamMemberBox);
    await Hive.openBox<PestModel>(AppConstants.pestBox);
    await Hive.openBox<ChemicalModel>(AppConstants.chemicalBox);
    await Hive.openBox<VisitModel>(AppConstants.visitBox);
    await Hive.openBox<ServiceReportModel>(AppConstants.serviceReportBox);
    await Hive.openBox<ActiveVisitModel>(AppConstants.activeVisitBox);
    await Hive.openBox(AppConstants.appSettingsBox);
  }

  static Future<void> seedMockData() async {
    final settingsBox = Hive.box(AppConstants.appSettingsBox);
    final supervisorBox = Hive.box<SupervisorModel>(AppConstants.supervisorBox);

    // Check if data already exists
    final isFirstLaunch = settingsBox.get(
      AppConstants.isFirstLaunchKey,
      defaultValue: true,
    );

    // Force seed if supervisor box is empty (safety check)
    if (!isFirstLaunch && supervisorBox.isNotEmpty) {
      print('✅ Mock data already seeded. Supervisor count: ${supervisorBox.length}');
      return;
    }

    print('🌱 Seeding mock data...');

    // Seed Supervisors
    await supervisorBox.put(
      'admin@pestcontrol.com',
      const SupervisorModel(
        id: 'SUP-001',
        name: 'Admin Supervisor',
        email: 'admin@pestcontrol.com',
        password: 'password123',
      ),
    );
    print('✅ Seeded supervisor: admin@pestcontrol.com');

    // Seed Team Members
    final teamMemberBox = Hive.box<TeamMemberModel>(AppConstants.teamMemberBox);
    await teamMemberBox.put(
      'T-01',
      const TeamMemberModel(id: 'T-01', name: 'Ahmed Hassan'),
    );
    await teamMemberBox.put(
      'T-02',
      const TeamMemberModel(id: 'T-02', name: 'Maria Garcia'),
    );
    await teamMemberBox.put(
      'T-03',
      const TeamMemberModel(id: 'T-03', name: 'John Doe'),
    );

    // Seed Customers and Projects
    final customerBox = Hive.box<CustomerModel>(AppConstants.customerBox);
    final projectBox = Hive.box<ProjectModel>(AppConstants.projectBox);

    // Customer 1: Global Logistics Hub
    await customerBox.put(
      'C001',
      const CustomerModel(
        id: 'C001',
        name: 'Global Logistics Hub',
        projectIds: ['P-101', 'P-102'],
      ),
    );
    await projectBox.put(
      'P-101',
      const ProjectModel(
        id: 'P-101',
        customerId: 'C001',
        name: 'Warehouse A - Pest Exclusion',
      ),
    );
    await projectBox.put(
      'P-102',
      const ProjectModel(
        id: 'P-102',
        customerId: 'C001',
        name: 'Main Office - General Disinfection',
      ),
    );

    // Customer 2: Sunshine Hospitality Group
    await customerBox.put(
      'C002',
      const CustomerModel(
        id: 'C002',
        name: 'Sunshine Hospitality Group',
        projectIds: ['P-201', 'P-202', 'P-203'],
      ),
    );
    await projectBox.put(
      'P-201',
      const ProjectModel(
        id: 'P-201',
        customerId: 'C002',
        name: 'Kitchen Sanitation Suite',
      ),
    );
    await projectBox.put(
      'P-202',
      const ProjectModel(
        id: 'P-202',
        customerId: 'C002',
        name: 'Guest Rooms - Bedbug Prevention',
      ),
    );
    await projectBox.put(
      'P-203',
      const ProjectModel(
        id: 'P-203',
        customerId: 'C002',
        name: 'Outdoor Pool Perimeter',
      ),
    );

    // Seed Pests
    final pestBox = Hive.box<PestModel>(AppConstants.pestBox);
    final pests = [
      'Ants',
      'Cockroaches',
      'Flies',
      'Rodents',
      'Termites',
      'Bedbugs',
      'Mosquitoes',
      'Spiders',
      'Fleas',
      'Ticks',
    ];

    for (int i = 0; i < pests.length; i++) {
      await pestBox.put(
        'PEST-${(i + 1).toString().padLeft(3, '0')}',
        PestModel(
          id: 'PEST-${(i + 1).toString().padLeft(3, '0')}',
          name: pests[i],
        ),
      );
    }

    // Seed Chemicals
    final chemicalBox = Hive.box<ChemicalModel>(AppConstants.chemicalBox);
    await chemicalBox.put(
      'CH-01',
      const ChemicalModel(
        id: 'CH-01',
        name: 'Pyrethroid Spray',
        unit: 'ml',
      ),
    );
    await chemicalBox.put(
      'CH-02',
      const ChemicalModel(
        id: 'CH-02',
        name: 'Boric Acid Powder',
        unit: 'g',
      ),
    );
    await chemicalBox.put(
      'CH-03',
      const ChemicalModel(
        id: 'CH-03',
        name: 'Fipronil Gel',
        unit: 'drops',
      ),
    );
    await chemicalBox.put(
      'CH-04',
      const ChemicalModel(
        id: 'CH-04',
        name: 'Permethrin Solution',
        unit: 'ml',
      ),
    );
    await chemicalBox.put(
      'CH-05',
      const ChemicalModel(
        id: 'CH-05',
        name: 'Diatomaceous Earth',
        unit: 'g',
      ),
    );

    // Mark as seeded
    await settingsBox.put(AppConstants.isFirstLaunchKey, false);

    print('✅ Mock data seeding complete!');
    print('   - Supervisors: ${supervisorBox.length}');
    print('   - Customers: ${Hive.box<CustomerModel>(AppConstants.customerBox).length}');
    print('   - Projects: ${Hive.box<ProjectModel>(AppConstants.projectBox).length}');
    print('   - Team Members: ${Hive.box<TeamMemberModel>(AppConstants.teamMemberBox).length}');
    print('   - Pests: ${Hive.box<PestModel>(AppConstants.pestBox).length}');
    print('   - Chemicals: ${Hive.box<ChemicalModel>(AppConstants.chemicalBox).length}');
  }
}

