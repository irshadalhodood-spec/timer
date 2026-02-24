import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_providers.dart';
import 'base_module/domain/entities/app_theme_singleton.dart';
import 'base_module/domain/entities/translation.dart';
import 'base_module/presentation/core/values/app_constants.dart';
import 'base_module/presentation/feature/network/blocs/network_bloc.dart';
import 'base_module/presentation/feature/theming/bloc/theme_bloc.dart';
import 'base_module/presentation/feature/translation/bloc/translation_bloc.dart';
import 'base_module/presentation/util/simple_bloc_observer.dart';
import 'dashboard_module/presentation/feature/screens/main_screen.dart';
import 'globals.dart';
import 'auth_module/presentation/feature/bloc/auth_bloc.dart';
import 'auth_module/presentation/feature/screens/onboarding_screen.dart';
import 'auth_module/presentation/splash_screen.dart';
import 'base_module/presentation/sync_bloc/sync_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';



class CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = CustomHttpOverrides();
  Bloc.observer = SimpleBlocObserver();
  await appTheme.init();
  await translation.init();

  runApp(
    RestartWidget(
      child: buildAppProviders(child: const EmployeeTrack()),
    ),
  );
}

class EmployeeTrack extends StatefulWidget {
  const EmployeeTrack({super.key});

  @override
  _EmployeeTrackState createState() => _EmployeeTrackState();
}

class _EmployeeTrackState extends State<EmployeeTrack> {
  ThemeBloc? _themeBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.window.onPlatformBrightnessChanged = () {
      if (appTheme.themeType == ThemeType.system) {
        _themeBloc ??= BlocProvider.of<ThemeBloc>(context);

        _themeBloc?.add(ChangeTheme(themeType: appTheme.themeType));
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<NetworkBloc, NetworkState>(
          listenWhen: (previousState, currentState) {
            return previousState == const NetworkState.offline() &&
                currentState == const NetworkState.online();
          },
          listener: (context, state) {
            if (state == const NetworkState.online()) {
              context.read<SyncBloc>().add(SyncTriggered());
              globalReloadCommonData();
              globalReloadUserData();
            }
          },
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, _) {
          return BlocBuilder<TranslationBloc, TranslationState>(
            builder: (context, state) {
              return LayoutBuilder(
                builder: (_, constraints) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    scaffoldMessengerKey: globalSnackBarKey,
                    title: AppConstants.appName,
                    theme: appTheme.themeData(context),
                    locale: translation.selectedLocale,
                    supportedLocales: translation.supportedLocales,
                    localizationsDelegates: const [
                      GlobalMaterialLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      FormBuilderLocalizations.delegate,
                    ],
                    initialRoute: '/splash',
                    routes: {
                      '/splash': (_) => const SplashScreen(),
                      '/onboarding': (_) => const OnboardingScreen(),
                      '/home': (ctx) {
                        final authState = ctx.read<AuthBloc>().state;
                        if (authState is AuthStateAuthenticated) {
                          return buildDashboardProviders(
                            context: ctx,
                            userId: authState.session.user.id,
                            child: const MainScreen(),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: key, child: widget.child);
  }
}
