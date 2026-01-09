import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/models/supervisor_model.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/dashboard/data/datasources/dashboard_local_datasource.dart';
import '../../features/dashboard/data/models/customer_model.dart';
import '../../features/dashboard/data/models/project_model.dart';
import '../../features/dashboard/data/models/team_member_model.dart';
import '../../features/service_report/data/datasources/service_report_local_datasource.dart';
import '../../features/service_report/data/models/chemical_model.dart';
import '../../features/service_report/data/models/pest_model.dart';
import '../../features/visits/data/datasources/visit_local_datasource.dart';
import '../../features/visits/data/models/visit_model.dart';
import '../constants/app_constants.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  sl.registerLazySingleton(() => const Uuid());

  // Hive Boxes
  sl.registerLazySingleton<Box<SupervisorModel>>(
    () => Hive.box<SupervisorModel>(AppConstants.supervisorBox),
  );
  sl.registerLazySingleton<Box<CustomerModel>>(
    () => Hive.box<CustomerModel>(AppConstants.customerBox),
  );
  sl.registerLazySingleton<Box<ProjectModel>>(
    () => Hive.box<ProjectModel>(AppConstants.projectBox),
  );
  sl.registerLazySingleton<Box<TeamMemberModel>>(
    () => Hive.box<TeamMemberModel>(AppConstants.teamMemberBox),
  );
  sl.registerLazySingleton<Box<PestModel>>(
    () => Hive.box<PestModel>(AppConstants.pestBox),
  );
  sl.registerLazySingleton<Box<ChemicalModel>>(
    () => Hive.box<ChemicalModel>(AppConstants.chemicalBox),
  );
  sl.registerLazySingleton<Box<VisitModel>>(
    () => Hive.box<VisitModel>(AppConstants.visitBox),
  );
  sl.registerLazySingleton<Box>(
    () => Hive.box(AppConstants.appSettingsBox),
  );

  // Data Sources
  sl.registerLazySingleton(() => AuthLocalDataSource(
        supervisorBox: sl(),
        settingsBox: sl(),
        uuid: sl(),
      ));

  sl.registerLazySingleton(() => DashboardLocalDataSource(
        customerBox: sl(),
        projectBox: sl(),
        teamMemberBox: sl(),
      ));

  sl.registerLazySingleton(() => VisitLocalDataSource(
        visitBox: sl(),
        uuid: sl(),
      ));

  sl.registerLazySingleton(() => ServiceReportLocalDataSource(
        pestBox: sl(),
        chemicalBox: sl(),
        uuid: sl(),
      ));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        authRepository: sl(),
      ));
}

