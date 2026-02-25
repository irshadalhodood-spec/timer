import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_module/data/network/api_client.dart';
import 'base_module/data/services/attendance_notification_service.dart';
import 'base_module/data/services/geo_service.dart';
import 'base_module/presentation/feature/network/blocs/network_bloc.dart';
import 'base_module/presentation/feature/theming/bloc/theme_bloc.dart';
import 'base_module/presentation/feature/translation/bloc/translation_bloc.dart';
import 'attendance_module/data/datasources/attendance_local_datasource.dart';
import 'attendance_module/data/datasources/json_attendance_api.dart';
import 'attendance_module/data/datasources/remote_first_attendance_api.dart';
import 'attendance_module/data/datasources/trackme_attendance_api.dart';
import 'attendance_module/data/repositories/attendance_repository_impl.dart';
import 'auth_module/data/datasources/trackme_auth_api.dart';
import 'auth_module/data/repositories/auth_repository_impl.dart';
import 'auth_module/domain/datasources/auth_api.dart';
import 'employee_track/data/datasources/break_record_local_datasource.dart';
import 'employee_track/data/repositories/break_record_repository_impl.dart';
import 'organization_module/data/repositories/employee_repository_impl.dart';
import 'organization_module/data/datasources/json_organization_api.dart';
import 'organization_module/data/datasources/remote_first_organization_api.dart';
import 'organization_module/data/datasources/trackme_organization_api.dart';
import 'organization_module/data/repositories/organization_repository_impl.dart';
import 'organization_module/domain/datasources/organization_api.dart';
import 'base_module/data/repositories/sync_queue_repository_impl.dart';
import 'attendance_module/domain/repositories/attendance_repository.dart';
import 'auth_module/domain/repositories/auth_repository.dart';
import 'employee_track/domain/repositories/break_record_repository.dart';
import 'organization_module/domain/repositories/employee_repository.dart';
import 'organization_module/domain/repositories/organization_repository.dart';
import 'base_module/domain/repositories/sync_queue_repository.dart';
import 'base_module/domain/repositories/working_hours_repository.dart';
import 'base_module/data/repositories/working_hours_repository_impl.dart';
import 'base_module/presentation/feature/live_time/live_time_cubit.dart';
import 'base_module/presentation/sync_bloc/sync_bloc.dart';
import 'dashboard_module/domain/attendance_bloc.dart';
import 'auth_module/presentation/feature/bloc/auth_bloc.dart';

Widget buildAppProviders({required Widget child}) {
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<GeoService>(create: (_) => GeoService()),
      RepositoryProvider<AttendanceNotificationService>(create: (_) => AttendanceNotificationService()),
      RepositoryProvider<ApiClient>(create: (_) => ApiClient()),
      RepositoryProvider<AuthApi>(create: (context) => TrackMeAuthApi(apiClient: context.read<ApiClient>())),
      RepositoryProvider<AuthRepository>(
        create: (context) => AuthRepositoryImpl(api: context.read<AuthApi>()),
      ),
      RepositoryProvider<AttendanceLocalDatasource>(create: (_) => AttendanceLocalDatasource()),
      RepositoryProvider<BreakRecordLocalDatasource>(create: (_) => BreakRecordLocalDatasource()),
      RepositoryProvider<AttendanceRepository>(
        create: (context) {
          final local = context.read<AttendanceLocalDatasource>();
          final breakLocal = context.read<BreakRecordLocalDatasource>();
          final apiClient = context.read<ApiClient>();
          final trackMe = TrackMeAttendanceApi(
            attendanceLocal: local,
            breakRecordLocal: breakLocal,
            apiClient: apiClient,
          );
          final jsonFallback = JsonAttendanceApi(
            attendanceLocal: local,
            breakRecordLocal: breakLocal,
          );
          return AttendanceRepositoryImpl(
            local: local,
            api: RemoteFirstAttendanceApi(trackMe: trackMe, jsonFallback: jsonFallback),
          );
        },
      ),
      RepositoryProvider<BreakRecordRepository>(
        create: (context) => BreakRecordRepositoryImpl(
          local: context.read<BreakRecordLocalDatasource>(),
        ),
      ),
      RepositoryProvider<SyncQueueRepository>(create: (_) => SyncQueueRepositoryImpl()),
      RepositoryProvider<WorkingHoursRepository>(
        create: (context) => WorkingHoursRepositoryImpl(apiClient: context.read<ApiClient>()),
      ),
      RepositoryProvider<OrganizationRepository>(
        create: (context) => OrganizationRepositoryImpl(
          authRepository: context.read<AuthRepository>(),
        ),
      ),
      RepositoryProvider<EmployeeRepository>(create: (_) => EmployeeRepositoryImpl()),
      RepositoryProvider<OrganizationApi>(
        create: (context) {
          final apiClient = context.read<ApiClient>();
          final trackMe = TrackMeOrganizationApi(
            organizationRepository: context.read<OrganizationRepository>(),
            employeeRepository: context.read<EmployeeRepository>(),
            apiClient: apiClient,
          );
          final jsonFallback = JsonOrganizationApi(
            organizationRepository: context.read<OrganizationRepository>(),
            employeeRepository: context.read<EmployeeRepository>(),
          );
          return RemoteFirstOrganizationApi(trackMe: trackMe, jsonFallback: jsonFallback);
        },
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<LiveTimeCubit>(lazy: false, create: (_) => LiveTimeCubit()),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: context.read<AuthRepository>())
            ..add(const AuthCheckRequested()),
        ),
        BlocProvider<SyncBloc>(
          create: (context) => SyncBloc(
            syncQueueRepository: context.read<SyncQueueRepository>(),
            attendanceRepository: context.read<AttendanceRepository>(),
            breakRecordRepository: context.read<BreakRecordRepository>(),
          ),
        ),
        BlocProvider<NetworkBloc>(
          lazy: false,
          create: (_) => NetworkBloc()..add(CheckNetwork()),
        ),
        BlocProvider<ThemeBloc>(lazy: false, create: (_) => ThemeBloc()),
        BlocProvider<TranslationBloc>(lazy: false, create: (_) => TranslationBloc()),
      ],
      child: child,
    ),
  );
}


Widget buildDashboardProviders({
  required BuildContext context,
  required String userId,
  required Widget child,
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<AttendanceBloc>(
        create: (ctx) => AttendanceBloc(
          attendanceRepository: context.read<AttendanceRepository>(),
          breakRecordRepository: context.read<BreakRecordRepository>(),
          syncQueueRepository: context.read<SyncQueueRepository>(),
          workingHoursRepository: context.read<WorkingHoursRepository>(),
          userId: userId,
        )..add(const AttendanceLoadRequested()),
      ),
    ],
    child: child,
  );
}
