import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'core/constants/app_constants.dart';
import 'core/database/database_service.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'core/models/active_visit_model.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_event.dart';
import 'features/visits/presentation/bloc/visit_bloc.dart';
import 'features/visits/data/models/visit_model.dart';
import 'features/dashboard/data/models/customer_model.dart';
import 'features/dashboard/data/models/project_model.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/dashboard/presentation/pages/profile_page.dart';
import 'features/dashboard/presentation/pages/visit_history_page.dart';
import 'features/visits/presentation/pages/visit_setup_page.dart';
import 'features/visits/presentation/pages/team_selection_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  await DatabaseService.init();
  await DatabaseService.seedMockData();

  // Initialize dependencies
  await initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth BLoC
        BlocProvider(
          create: (context) => sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),

        // Dashboard BLoC
        BlocProvider(
          create: (context) => DashboardBloc(
            activeVisitBox: Hive.box<ActiveVisitModel>(AppConstants.activeVisitBox),
            visitBox: Hive.box<VisitModel>(AppConstants.visitBox),
          )..add(LoadDashboardDataEvent()),
        ),

        // Visit BLoC
        BlocProvider(
          create: (context) => VisitBloc(
            customerBox: Hive.box<CustomerModel>(AppConstants.customerBox),
            projectBox: Hive.box<ProjectModel>(AppConstants.projectBox),
            activeVisitBox: Hive.box<ActiveVisitModel>(AppConstants.activeVisitBox),
            visitBox: Hive.box<VisitModel>(AppConstants.visitBox),
            uuid: const Uuid(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Pest Control Manager',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading || state is AuthInitial) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (state is AuthAuthenticated) {
              return const DashboardPage();
            } else {
              return const LoginPage();
            }
          },
        ),
        routes: {
          LoginPage.routeName: (context) => const LoginPage(),
          RegisterPage.routeName: (context) => const RegisterPage(),
          DashboardPage.routeName: (context) => const DashboardPage(),
          ProfilePage.routeName: (context) => const ProfilePage(),
          VisitSetupPage.routeName: (context) => const VisitSetupPage(),
          VisitHistoryPage.routeName: (context) => const VisitHistoryPage(),
        },
      ),
    );
  }
}

